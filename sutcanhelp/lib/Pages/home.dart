import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sutcanhelp/Pages/pageone.dart';
import 'package:sutcanhelp/Pages/signIn.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String emailLogin = '...';
  String name = '...';
  String uids = '2B9610HE5nc3UMru74qseGrSVer2';
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  List<myData> allData = [];
  @override
  void initState() {
    findDisplayName();
    getdata();
    //   DatabaseReference ref = FirebaseDatabase.instance.reference();
    //   ref.child('Users').once().then((DataSnapshot snap) {
    //     var keys = snap.value.uids;
    //     var data = snap.value;
    //     allData.clear();
    // for(var key in keys){
    //   myData d = new myData(
    //     data[key]['Email'],
    //     data[key]['Name'],
    //   );
    //   allData.add(d);
    // }
    //   });
    super.initState();
  }

  void getdata() async {
    DatabaseReference databaseReference =
        firebaseDatabase.reference().child('Users');
    await databaseReference.once().then((DataSnapshot dataSnapshot) {
      // print('Data ==> ${datasnapshot.value}');
      Map<dynamic, dynamic> values = dataSnapshot.value;
      values.forEach((key, values) {
        if (key == uids) {
          print(values['Email']);
          setState(() {
            name = values['Name'];
          });
          print(values['Name']);
        }

        // print(values['Name']);
      });
    });
  }

  bool loaded = true;

  Widget singoutButton() {
    return IconButton(
      icon: Icon(Icons.exit_to_app),
      tooltip: 'Sing out',
      onPressed: () {
        loader1();
        setState(() {
          loaded = false;
        });
        Timer(Duration(seconds: 5), () {
          Navigator.of(context).pop();
        });
        // loader1();
        myAlert();
      },
    );
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are You Sure ?'),
            content: Text('Do You Want Sing Out ?'),
            actions: <Widget>[cancleButton(), okButton()],
          );
        });
  }

  Widget cancleButton() {
    return FlatButton(
      child: Text('Cancle'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget okButton() {
    return FlatButton(
      child: Text('OK'),
      onPressed: () {
        Navigator.of(context).pop();
        procrssSignOut();
      },
    );
  }

  Future<void> procrssSignOut() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut().then((response) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => Pageone());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    });
  }

  Widget showDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          showHeader(),
          Center(
              child: Text('$name',
                  style: TextStyle(fontSize: 20.0, color: Colors.black)))
        ],
      ),
    );
  }

  Widget showHeader() {
    return DrawerHeader(
      child: Column(
        children: <Widget>[
          showLogoActor(),
          SizedBox(height: 20.0),
          showEmailLogin(),
        ],
      ),
      decoration: BoxDecoration(color: Colors.blue.shade700),
    );
  }

  Widget showLogoActor() {
    return Container(
      width: 80.0,
      height: 80.0,
      child: Image.asset('images/logoActor.jpg'),
    );
  }

  Future<void> findDisplayName() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    setState(() {
      emailLogin = firebaseUser.email;
      uids = firebaseUser.uid;
    });
    return emailLogin;
  }

  Widget showEmailLogin() {
    return Text(
      '$emailLogin',
      style: TextStyle(fontSize: 20.0, color: Colors.white),
    );
  }

  Widget loader() {
    return SpinKitDualRing(
      color: Colors.red,
      size: 50.0,
    );
  }

  Future<bool> loader1() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: loader(),
      ),
    );
  }

  //  void databasedadad() {
  // setState(() {
  //     database.reference().child('Users').once().then(DataSnapshot snapshot){
  //         Map<dynamic, dynamic> list = snapshot.value;
  //       };
  //     });
  //   }

  //  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: Text('ssss'),
        actions: <Widget>[
          singoutButton(),
        ],
      ),
      drawer: showDrawer(),
      drawerScrimColor: Colors.white30,
      body: ListView(
        children: <Widget>[
          Center(
            child: loader(),
          )
        ],
      ),
    );
  }
}

class myData {
  myData(data, data2);
}
