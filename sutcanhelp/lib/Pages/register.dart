import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sutcanhelp/Pages/pageone.dart';
import 'package:sutcanhelp/Pages/signIn.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //สร้าง Form เผื่อเอาไว้เก็บตัวแปร
  final formKey = GlobalKey<FormState>();
  String emailString, passString, nameString, repassString;
  bool loaded = true;
  // Method
  // @override
  // void initState() {
  //   super.initState();
  //   setnull();
  // }

  // void setnull() {
  //   emailString = 'null';
  //   passString = null;
  //   repassString = null;
  //   nameString = null;
  // }

  Widget registerButton() {
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      shadowColor: Colors.black54,
      elevation: 5.0,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        height: 56.0,
        onPressed: () {
          print('สมัคร');
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            print(
                'Username = $emailString, password = $passString, name = $nameString');
            print('Password = $passString, Repassword = $repassString');
            if (passString == repassString) {
              registerThread();
            } else {
              setState(() {
                loader();
                loaded = false;
              });
              Timer(Duration(seconds: 2), () {
                Navigator.of(context).pop();
                passAlert();
              });
            }
          }
        },
        child: Text('สมัครสมาชิก',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.bold)),
      ),
      color: Colors.greenAccent[700],
    );
  }

  Widget cancelButton() {
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      shadowColor: Colors.black54,
      elevation: 5.0,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        height: 56.0,
        onPressed: () {
          print("ยกเลิก");
          MaterialPageRoute materialPageRoute =
              MaterialPageRoute(builder: (BuildContext context) => Pageone());
          Navigator.of(context).push(materialPageRoute); //
        },
        child: Text('ยกเลิก',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.bold)),
      ),
      color: Colors.redAccent[700],
    );
  }

  Widget emailText() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        fillColor: Colors.lightBlue[100],
        filled: true,
        hintText: "Email",
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        prefixIcon: Icon(
          Icons.email,
          color: Colors.black,
        ),
      ),
      validator: (String value) {
        if (!((value.contains('@')) && (value.contains('.')))) {
          return 'Please Type Email in Email Format Exp. you@email.com';
        } else {
          return null;
        }
      },
      onSaved: (String email) {
        emailString = email;
      },
    );
  }

  Widget passwordText() {
    return TextFormField(
      decoration: InputDecoration(
        fillColor: Colors.lightBlue[100],
        filled: true,
        hintText: "Password",
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        prefixIcon: Icon(
          Icons.lock_open,
          color: Colors.black,
        ),
      ),
      validator: (String value) {
        if (value.length < 6) {
          return 'password More 6 Charactor';
        } else {
          return null;
        }
      },
      onSaved: (String pass) {
        passString = pass;
      },
      obscureText: true,
    );
  }

  Widget repasswordText() {
    return TextFormField(
      decoration: InputDecoration(
        fillColor: Colors.lightBlue[100],
        filled: true,
        hintText: "Re-type Password",
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.black,
        ),
      ),
      validator: (String value) {
        if (((value.length < 6) || (/*checkpass()*/ false))) {
          return 'password More 6 Charactor';
        } else {
          return null;
        }
      },
      onSaved: (String repass) {
        repassString = repass;
      },
      obscureText: true,
    );
  }

  Widget nameText() {
    return TextFormField(
      decoration: InputDecoration(
        fillColor: Colors.lightBlue[100],
        filled: true,
        hintText: "Name",
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        prefixIcon: Icon(
          Icons.perm_identity,
          color: Colors.black,
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please Fill Your Name in the Blank';
        } else {
          return null;
        }
      },
      onSaved: (String name) {
        nameString = name;
      },
    );
  }

  Widget topText() {
    return Text('สมัครสมาชิก',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 45,
          foreground: Paint()
            ..style = PaintingStyle.fill
            ..strokeWidth = 10
            ..color = Colors.white,
        ));
  }

  // checkpass() {
  //   print('พาสหลัก $passString  พาสรอง $repassString');
  //   if (passString.toString() == repassString.toString()) {
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }

  Future<void> registerThread() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailString, password: passString)
        .then((currentUser) {
      // inputData();
      loader();
      setState(() {
        loaded = false;
      });
      Timer(Duration(seconds: 2), () {
        Navigator.of(context).pop();
        setupUser();
      });

      print('Register Success for Email = $emailString');
    }).catchError((response) {
      String title = response.code;
      String message = response.message;
      print('title = $title, message = $message');

      setState(() {
        loader();
        loaded = false;
      });
      Timer(Duration(seconds: 2), () {
        Navigator.of(context).pop();
        myAlert(title, message);
      });
    });
  }

  void myAlert(title, message) {
    Alert(
        context: context,
        title: message,
        //  desc: message,
        type: AlertType.error,
        buttons: [
          DialogButton(
            child: Text(
              'OK',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ]).show();
  }

  void passAlert() {
    Alert(type: AlertType.error, context: context, title: 'Password Not match',
        //  desc: message,
        buttons: [
          DialogButton(
            child: Text(
              'OK',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ]).show();
  }

  load() {
    return SpinKitChasingDots(
      color: Colors.white,
      size: 75.0,
    );
  }

  Future<bool> loader() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: load(),
            backgroundColor: Colors.lightBlue[400],
          );
        });
  }

  void successRegister() {
    Alert(type: AlertType.success, context: context, title: 'Register Success',
        //  desc: message,
        buttons: [
          DialogButton(
            child: Text(
              'OK',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ]).show();
  }

// var userUid;

//   Future<String> inputData() async {
//     final FirebaseUser user = await FirebaseAuth.instance.currentUser();
//     userUid = user.uid.toString();
//     return userUid;
//   }

  Future<void> setupUser() async {
    DatabaseReference firebaseAuth = FirebaseDatabase.instance.reference();
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var userid = user.uid.toString();
    await firebaseAuth.child("Users").child(userid).set({
      'Email': emailString,
      'Password': passString,
      'Name': nameString,
    });
    // setState(() {
    //   setnull();
    // });
    successRegister();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Register'),
      //   actions: <Widget>[],
      // ),

      backgroundColor: Colors.lightBlueAccent,
      body: Container(
        margin: MediaQuery.of(context).padding,
        child: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.all(30.0),
            children: <Widget>[
              Column(
                children: <Widget>[
                  topText(),
                  SizedBox(height: 30.0),
                  emailText(),
                  SizedBox(height: 15.0),
                  passwordText(),
                  SizedBox(height: 15.0),
                  repasswordText(),
                  SizedBox(height: 15.0),
                  nameText(),
                  SizedBox(height: 30.0),
                  registerButton(),
                  SizedBox(height: 15.0),
                  cancelButton(),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: <Widget>[, ],
                  //   ),
                  // ),
                  // )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
