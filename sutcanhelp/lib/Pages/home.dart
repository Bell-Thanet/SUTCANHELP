import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sutcanhelp/Pages/homepage.dart';
import 'package:sutcanhelp/Pages/signIn.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String emailLogin = '...';

  @override
  void initState() {
    super.initState();
    findDisplayName();
  }

  Widget singoutButton() {
    return IconButton(
      icon: Icon(Icons.exit_to_app),
      tooltip: 'Sing out',
      onPressed: () {
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
          MaterialPageRoute(builder: (BuildContext context) => HomePage());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    });
  }

  Widget showDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[showHeader()],
      ),
    );
  }

  Widget showHeader() {
    return DrawerHeader(
      child: Column(
        children: <Widget>[
          showLogoActor(),
          SizedBox(height: 20.0),
          showEmailLogin()
        ],
      ),
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
    });
  }

  Widget showEmailLogin() {
    return Text(
      '$emailLogin',
      style: TextStyle(fontSize: 20.0),
    );
  }

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
      body: ListView(
        children: <Widget>[],
      ),
    );
  }
}
