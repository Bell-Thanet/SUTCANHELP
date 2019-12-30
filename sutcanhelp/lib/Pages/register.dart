import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sutcanhelp/Pages/homepage.dart';
import 'package:sutcanhelp/Pages/signIn.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //สร้าง Form เผื่อเอาไว้เก็บตัวแปร
  final formKey = GlobalKey<FormState>();
  String emailString, passString, nameString, repassString;
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
    return RaisedButton(
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
            passAlert();
          }
        }
      },
      child: Text('สมัครสมาชิก',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            foreground: Paint()
              ..style = PaintingStyle.fill
              ..strokeWidth = 10
              ..color = Colors.lightBlueAccent,
          )),
      color: Colors.white,
    );

    // IconButton(
    //   icon: Icon(Icons.account_circle),
    //   onPressed: () {
    //     print('click');
    //     if (formKey.currentState.validate()) {
    //       formKey.currentState.save();
    //     }
    //   },
    // );
  }

  Widget cancelButton() {
    return FlatButton(
        child: Text('ยกเลิก',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              foreground: Paint()
                ..style = PaintingStyle.fill
                ..strokeWidth = 10
                ..color = Colors.lightBlueAccent,
            )),
        onPressed: () {
          print("ยกเลิก");
          MaterialPageRoute materialPageRoute =
              MaterialPageRoute(builder: (BuildContext context) => HomePage());
          Navigator.of(context).push(materialPageRoute); //
        },
        color: Colors.white);
  }

  Widget emailText() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
          icon: Icon(
            Icons.email,
            color: Colors.white,
            size: 48.0,
          ),
          labelText: 'Email',
          labelStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          helperText: 'Type Your Email',
          helperStyle: TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.italic,
          )),
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
          icon: Icon(
            Icons.lock,
            color: Colors.white,
            size: 48.0,
          ),
          labelText: 'Password :',
          labelStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          helperText: 'Type Your password more 6 Charactor',
          helperStyle: TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.italic,
          )),
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
          icon: Icon(
            Icons.lock,
            color: Colors.white,
            size: 48.0,
          ),
          labelText: 'Re-type Password :',
          labelStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )),
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
          icon: Icon(
            Icons.perm_identity,
            color: Colors.white,
            size: 48.0,
          ),
          labelText: 'Name :',
          labelStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )),
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
      setupUser();
      print('Register Success for Email = $emailString');
    }).catchError((response) {
      String title = response.code;
      String message = response.message;
      print('title = $title, message = $message');
      myAlert(title, message);
    });
  }

  void myAlert(title, message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: ListTile(
              leading: Icon(
                Icons.error,
                color: Colors.red,
                size: 48,
              ),
              title: Text(
                title,
                style: TextStyle(color: Colors.red),
              ),
            ),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void passAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Password Not match'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void successRegister() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Register Success'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
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
      appBar: AppBar(
        title: Text('Register'),
        actions: <Widget>[],
      ),
      backgroundColor: Colors.lightBlueAccent,
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(30.0),
          children: <Widget>[
            Column(
              children: <Widget>[
                topText(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: emailText(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: passwordText(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: repasswordText(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: nameText(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[cancelButton(), registerButton()],
                  ),
                ),
                // )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
