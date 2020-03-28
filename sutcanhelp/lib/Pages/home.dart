import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sutcanhelp/Pages/learnBook.dart';
import 'package:sutcanhelp/Pages/map/map.dart';
import 'package:sutcanhelp/Pages/pageone.dart';
import 'package:sutcanhelp/Pages/profile.dart';
import 'package:sutcanhelp/Pages/repairComputer.dart';
import 'package:sutcanhelp/Pages/sosAnimal.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class Message {
  String title;
  String body;
  String message;
  Message(title, body, message) {
    this.title = title;
    this.body = body;
    this.message = message;
  }
}

class _HomeState extends State<Home> {
  String emailLogin = '...';
  String name = '...';
  String uids = '';
  String pullURL = '';
  // FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // findDisplayName();
    // getdata();
    // showDrawer();
    // showHeader();
    _messages = List<Message>();
    _getToken();
    _configureFirebaseListeners();
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<Message> _messages;
  _getToken() {
    _firebaseMessaging.getToken().then((deviceToken) {
      print("Device Token: $deviceToken");
    });
  }

  _configureFirebaseListeners() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('onMessage: $message');
      _setMessage(message);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('onMessage: $message');
      _setMessage(message);
    }, onResume: (Map<String, dynamic> message) async {
      print('onMessage: $message');
      _setMessage(message);
    });
  }

  _setMessage(Map<String, dynamic> message) {
    final notification = message['notification'];
    final data = message['data'];
    final String title = notification['title'];
    final String body = notification['body'];
    final String mMessage = data['message'];
    setState(() {
      Message m = Message(title, body, message);
      _messages.add(m);
    });
  }

  void getdata() async {
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    String uids = firebaseUser.uid;
    final DocumentReference documentReference =
        Firestore.instance.document('Users/$uids');
    documentReference.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        setState(() {
          name = datasnapshot.data['Name'];
          pullURL = datasnapshot.data['URL'];
          print('Name = $name /t URL = $pullURL');
        });
      }
    });
  }

  // void getdata() async {
  //   DatabaseReference databaseReference =
  //       firebaseDatabase.reference().child('Users');
  //   await databaseReference.once().then((DataSnapshot dataSnapshot) {
  //     // print('Data ==> ${datasnapshot.value}');
  //     Map<dynamic, dynamic> values = dataSnapshot.value;
  //     values.forEach((key, values) {
  //       if (key == uids) {
  //         print(values['Email']);
  //         setState(() {
  //           name = values['Name'];
  //           pullURL = values['URL'];
  //         });
  //         print(values['Name']);
  //       }
  //       // print(values['Name']);
  //     });
  //   });
  // }

  bool loaded = true;

  Widget singoutButton() {
    return IconButton(
      icon: Icon(Icons.exit_to_app),
      tooltip: 'Sing out',
      onPressed: () {
        // loader1();
        setState(() {
          loaded = false;
        });
        // Timer(Duration(seconds: 5), () {
        //   Navigator.of(context).pop();
        // });
        // loader1();
        myAlert();
      },
    );
  }

  void myAlert() {
    Alert(
        context: context,
        title: 'Are You Sure ?',
        content: Text('Do You Want Sing Out ?'),
        buttons: [
          DialogButton(
            child: Text(
              'OK',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              procrssSignOut();
            },
          ),
          DialogButton(
            child: Text(
              'Cancle',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ]).show();
  }

  Future<void> procrssSignOut() async {
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
          // profileList(),
          sosAnimal(),
          repairComputer(),
          learnbook(),
          // logoutList(),
        ],
      ),
    );
  }

  Widget showHeader() {
    return DrawerHeader(
      child: Image(image: AssetImage('images/logoSUTCANHELP.png')),
      decoration: BoxDecoration(color: Colors.blue.shade700),
    );
  }

  Widget sosAnimal() {
    return ListTile(
      leading: Icon(
        Icons.pets,
        color: Colors.blue,
      ),
      title: Text('จับสัตว์',
          style: TextStyle(
            fontSize: 18.0,
          )),
      onTap: () {
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => SosAnimal());
        Navigator.of(context).pushAndRemoveUntil(
            materialPageRoute, (Route<dynamic> route) => true);
      },
    );
  }

  Widget repairComputer() {
    return ListTile(
      leading: Icon(
        Icons.computer,
        color: Colors.blue,
      ),
      title: Text('ซ้อมคออมพิวเตอร์',
          style: TextStyle(
            fontSize: 18.0,
          )),
      onTap: () {
        MaterialPageRoute materialPageRoute = MaterialPageRoute(
            builder: (BuildContext context) => RepairComputer());
        Navigator.of(context).pushAndRemoveUntil(
            materialPageRoute, (Route<dynamic> route) => true);
      },
    );
  }

  Widget learnbook() {
    return ListTile(
      leading: Icon(
        Icons.book,
        color: Colors.blue,
      ),
      title: Text('นัดติวหนังสือ',
          style: TextStyle(
            fontSize: 18.0,
          )),
      onTap: () {
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => LearnBook());
        Navigator.of(context).pushAndRemoveUntil(
            materialPageRoute, (Route<dynamic> route) => true);
      },
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

  Widget logoCircle() {
    return CircleAvatar(
      radius: 40,
      backgroundColor: Colors.blue[900],
      child: ClipOval(
        child: SizedBox(height: 70, width: 70, child: showLogoActor()),
      ),
    );
  }

  Widget showLogoActor() {
    if (pullURL != 'null') {
      return Container(
        // width: 80.0,
        // height: 80.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage('$pullURL'),
              fit: BoxFit.fill,
            )),
      );
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
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    setState(() {
      emailLogin = firebaseUser.email;
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

  Widget title() {
    return Text(
      "แจ้งเหตุด่วน",
      style: TextStyle(
        color: Colors.black,
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Widget bottomCircel() {
  //   return RaisedButton(
  //     child: Text('SOS',style: TextStyle(color:Colors.lightBlueAccent,fontSize: 40,fontWeight: FontWeight.bold),),
  //     color: Colors.red,
  //     splashColor: Colors.red[300],shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(400)
  //     ),
  //     highlightElevation: 50,padding: const EdgeInsets.all(50.0),
  //     onPressed: (){},
  //   );
  // }

  // Widget bottomCircel() {
  //   return FloatingActionButton(
  //     onPressed: () {},
  //     backgroundColor: Colors.redAccent,
  //     foregroundColor: Colors.red,
  //     elevation: 20.0,
  //     child: Text("SOS",style: TextStyle(color:Colors.lightBlueAccent,fontWeight: FontWeight.bold,fontSize: 20.0),),

  //   );
  // }
  Widget sosbuttom() {
    return Center(
      child: CircleAvatar(
        radius: 120,
        backgroundColor: Colors.red,
        child: ClipOval(
          child: SizedBox(width: 300.0, height: 300.0, child: bottomsos()),
        ),
      ),
    );
  }

  Widget bottomsos() {
    return Center(
      child: InkWell(
        onTap: () {
          MaterialPageRoute materialPageRoute =
              MaterialPageRoute(builder: (BuildContext context) => MapPage1());
          Navigator.of(context).pushAndRemoveUntil(
              materialPageRoute, (Route<dynamic> route) => true);
        },
        child: Container(
          padding: const EdgeInsets.all(80.0),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.redAccent,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black,
                    //blurRadius: 0.3,
                    blurRadius: 6.0,
                    offset: new Offset(0.0, 4.0))
              ]),
          child: Text(
            'SOS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
  // Widget bottomsos() {
  //   return ClipRRect(
  //     child: Stack(
  //       children: <Widget>[],
  //     ),
  //   );
  // }

  Widget page = null;
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.lightBlueAccent,
  //     appBar: AppBar(
  //       title: Text('HOME'),
  //       actions: <Widget>[
  //         singoutButton(),
  //       ],
  //     ),
  //     // drawer: showDrawer(),

  //     drawerScrimColor: Colors.white30,
  //     body: ListView(
  //       children: <Widget>[
  //         Padding(
  //           padding: const EdgeInsets.all(40),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: <Widget>[
  //               // title(),
  //               // SizedBox(
  //               //   height: 20.0,
  //               // ),
  //               sosbuttom(),
  //               // bottomsos(),
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: Center(
          child: Text(
            'SOS',
            style: TextStyle(fontSize: 25),
          ),
        ),
        actions: <Widget>[
          singoutButton(),
        ],
      ),
      drawer: showDrawer(),
      drawerScrimColor: Colors.white30,
      body: Container(
          // width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(child: sosbuttom()),
        ],
      )),
    );
  }
}
