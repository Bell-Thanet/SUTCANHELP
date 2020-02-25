import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sutcanhelp/Pages/home.dart';
import 'package:sutcanhelp/Pages/register.dart';
import 'package:sutcanhelp/Pages/signIn.dart';
import 'package:sutcanhelp/widget/bottomNavigation.dart';



class Pageone extends StatefulWidget {
  @override
  _PageoneState createState() => _PageoneState();
}

class _PageoneState extends State<Pageone> {
   void initState() {
    super.initState();
    checkStatus();
  }
  

  Future<void> checkStatus() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    if (firebaseUser != null) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => BottomNavigation());
          // MaterialPageRoute(builder: (BuildContext context) => Home());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    }
  }

  Widget sutText() {
    return Text("SUT",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 70,
          foreground: Paint()
            ..style = PaintingStyle.fill
            ..strokeWidth = 5
            ..color = Colors.white,
        ));
  }

  Widget canText() {
    return Text("CAN",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 70,
          foreground: Paint()
            ..style = PaintingStyle.fill
            ..strokeWidth = 5
            ..color = Colors.white,
        ));
  }

  Widget helpText() {
    return Text("HELP",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 70,
          foreground: Paint()
            ..style = PaintingStyle.fill
            ..strokeWidth = 5
            ..color = Colors.white,
        ));
  }

  Widget forpuText() {
    return Text("FOR PUBLIC",
        // textAlign: TextAlign.right,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 25,
          foreground: Paint()
            ..style = PaintingStyle.fill
            ..strokeWidth = 10
            ..color = Colors.white,
        ));
  }

  // Widget registerRountButton() {
  //   return RaisedButton(
  //     onPressed: () {
  //       MaterialPageRoute materialPageRoute = MaterialPageRoute(
  //           builder: (BuildContext context) => RegisterPage());
  //       Navigator.of(context).push(materialPageRoute);
  //     },
  //     child: Text('สมัครสมาชิก',
  //         // textAlign: TextAlign.center,
  //         style: TextStyle(
  //           fontWeight: FontWeight.w800,
  //           fontSize: 20,
  //           foreground: Paint()
  //             ..style = PaintingStyle.fill
  //             ..strokeWidth = 10
  //             ..color = Colors.lightBlueAccent,
  //         )),
  //     color: Colors.white,
  //   );
  // }

  Widget registerRountButton() {
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      shadowColor: Colors.black54,
      elevation: 5.0,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        height: 56.0,
        onPressed: () {
          MaterialPageRoute materialPageRoute = MaterialPageRoute(
              builder: (BuildContext context) => RegisterPage());
          Navigator.of(context).push(materialPageRoute);
        },
        child: Text('สมัครสมาชิก',
            style: TextStyle(
                color: Colors.lightBlue,
                fontSize: 25.0,
                fontWeight: FontWeight.bold)),
      ),
      color: Colors.white,
    );
  }

  Widget signInRountButton() {
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      shadowColor: Colors.black54,
      elevation: 5.0,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        height: 56.0,
        onPressed: () {
          MaterialPageRoute materialPageRoute =
              MaterialPageRoute(builder: (BuildContext context) => LoginPage());
          Navigator.of(context).push(materialPageRoute);
        },
        child: Text('เข้าสู่ระบบ',
            style: TextStyle(
                color: Colors.lightBlue,
                fontSize: 25.0,
                fontWeight: FontWeight.bold)),
      ),
      color: Colors.white,
    );
  }

 
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlueAccent,
        body: Container(
          margin: MediaQuery.of(context).padding,
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    sutText(),
                    canText(),
                    helpText(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 65, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          forpuText(),
                          
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                      child: Column(
                        children: <Widget>[
                          signInRountButton(),
                          SizedBox(
                            height: 20.0,
                          ),
                          registerRountButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

