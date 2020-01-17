import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:sutcanhelp/Pages/home.dart';
import 'package:sutcanhelp/Pages/profile.dart';

class BottomNavigationProfile extends StatefulWidget {
  @override
  _BottomNavigationProfileState createState() => _BottomNavigationProfileState();
}

class _BottomNavigationProfileState extends State<BottomNavigationProfile> {
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: Colors.blue,
      backgroundColor: Colors.lightBlueAccent,
      buttonBackgroundColor: Colors.white,
      height: 60,
      items: <Widget>[
        Icon(Icons.airline_seat_flat_angled, size: 20, color: Colors.black),
        Icon(Icons.notifications_active, size: 20, color: Colors.black),
        Icon(Icons.home, size: 20, color: Colors.black),
        Icon(Icons.account_circle, size: 20, color: Colors.black),
        Icon(Icons.phone_in_talk, size: 20, color: Colors.black),
      ],
      index: 3,
      animationDuration: Duration(milliseconds: 200),
      animationCurve: Curves.bounceInOut,
      onTap: (index) {
        if(index == 2){
          MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => Home());
        Navigator.of(context).pushAndRemoveUntil(
            materialPageRoute, (Route<dynamic> route) => false);
        }
        debugPrint('Current Index is $index');
      },
    );
  }
}