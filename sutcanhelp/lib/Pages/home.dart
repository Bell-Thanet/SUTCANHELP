import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sutcanhelp/Pages/pageone.dart';
import 'package:sutcanhelp/Pages/profile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String emailLogin = '...';
  String name = '...';
  String uids = '';
  String pullURL = '';
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  // Widget currentWidget = Home();

  @override
  void initState() {
    findDisplayName();
    getdata();
    showDrawer();
    showHeader();
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
            pullURL = values['URL'];
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
          profileList(),
          logoutList(),
        ],
      ),
    );
  }

  Widget showHeader() {
    return DrawerHeader(
      child: Column(
        children: <Widget>[
          showLogoActor(),
          SizedBox(height: 15.0),
          showNameLogin(),
          showEmailLogin(),
        ],
      ),
      decoration: BoxDecoration(color: Colors.blue.shade700),
    );
  }

  // Widget showLogoActornull() {
  //   return Container(
  //     width: 80.0,
  //     height: 80.0,
  //     decoration: BoxDecoration(
  //         shape: BoxShape.circle,
  //         image: DecorationImage(
  //           image: (pullURL != null)
  //               ? NetworkImage('$pullURL')
  //               : NetworkImage(
  //                   'https://fiverr-res.cloudinary.com/images/t_main1,q_auto,f_auto/gigs/98381915/original/9a98da91fcc1709763e92016d13756af640abcb7/design-minimalist-flat-line-vector-avatar-of-you.jpg'),
  //           fit: BoxFit.fill,
  //         )),
  //   );
  // }
  Widget showLogoActor() {
    if (pullURL != null) {
      return pullURL.isNotEmpty
          ? Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage('$pullURL'),
                    fit: BoxFit.fill,
                  )),
            )
          : Container();
    } else {
      return Container(
        width: 80.0,
        height: 80.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('images/logoActor.jpg'),
              fit: BoxFit.fill,
            )),
      );
    }
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
      style: TextStyle(
        fontSize: 15.0,
        color: Colors.white,
      ),
    );
  }

  Widget showNameLogin() {
    return Text(
      '$name',
      style: TextStyle(fontSize: 20.0, color: Colors.white),
    );
  }

  Widget profileList() {
    return ListTile(
      leading: Icon(Icons.person),
      title: Text('Profile',
          style: TextStyle(
            fontSize: 18.0,
          )),
      onTap: () {
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => Profile());
        Navigator.of(context).pushAndRemoveUntil(
            materialPageRoute, (Route<dynamic> route) => false);

        // MaterialPageRoute materialPageRoute =
        //     MaterialPageRoute(builder: (BuildContext context) => Profile());
        // Navigator.of(context).push(materialPageRoute);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => Profile(),
        //         settings: RouteSettings(arguments: 'aaaa')));
      },
    );
  }

  Widget logoutList() {
    return ListTile(
      leading: Icon(Icons.arrow_back),
      title: Text(
        'Logout',
        style: TextStyle(
          fontSize: 18.0,
        ),
      ),
      onTap: () {
        // loader1();
        // setState(() {
        //   loaded = false;
        // });
        // Timer(Duration(seconds: 5), () {
        //   Navigator.of(context).pop();
        // });
        // // loader1();
        myAlert();
      },
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
