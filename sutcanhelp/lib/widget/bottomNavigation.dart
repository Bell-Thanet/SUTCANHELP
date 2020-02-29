import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:sutcanhelp/Pages/firstAid.dart';
import 'package:sutcanhelp/Pages/home.dart';
import 'package:sutcanhelp/Pages/map/map.dart';
import 'package:sutcanhelp/Pages/profile.dart';
import 'package:sutcanhelp/Pages/telephone.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  Widget page = Home();

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
        // myAlert();
        setState(() {
          page=Profile();
        });
      },
    );
  }

  Widget showDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          // showHeader(),
          // profileList(),
          logoutList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: showDrawer(),
      body: page,
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.blue,
        backgroundColor: Colors.lightBlueAccent,
        buttonBackgroundColor: Colors.white,
        height: 65,
        items: <Widget>[
          Icon(Icons.airline_seat_flat_angled, size: 20, color: Colors.black),
          Icon(Icons.notifications_active, size: 20, color: Colors.black),
          Icon(Icons.home, size: 50, color: Colors.black),
          Icon(Icons.account_circle, size: 20, color: Colors.black),
          Icon(Icons.phone_in_talk, size: 20, color: Colors.black),
        ],
        index: 2,
        animationDuration: Duration(milliseconds: 200),
        animationCurve: Curves.bounceInOut,
        onTap: (index) {
          switch (index) {
            case 0:
              setState(() {
                page = FirstAid();
              });
              break;
            case 1:
              setState(() {
                page = Home();
              });
              break;
            case 2:
              setState(() {
                page = Home();
              });
              break;
            case 3:
              setState(() {
                page = Profile();
              });
              break;
            case 4:
              setState(() {
                page = Telephone();
              });
              break;
          }
          debugPrint('Current Index is $index');
        },
      ),
    );
  }
}
