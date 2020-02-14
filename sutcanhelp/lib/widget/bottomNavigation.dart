import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:sutcanhelp/Pages/aaa.dart';
import 'package:sutcanhelp/Pages/home.dart';
import 'package:sutcanhelp/Pages/map.dart';
import 'package:sutcanhelp/Pages/map/map.dart';
import 'package:sutcanhelp/Pages/profile.dart';


class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  Widget page = Home();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                page = Home();
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
                page = MapPage1();
              });
              break;
          }
          debugPrint('Current Index is $index');
        },
      ),
    );
  }
}
