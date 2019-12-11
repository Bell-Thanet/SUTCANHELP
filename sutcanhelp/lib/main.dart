import 'package:flutter/material.dart';
import 'Setup/signIn.dart';

void main() => runApp(AppNew());

class AppNew extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SUT CAN HELP',
        color: Colors.lightBlueAccent,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          // backgroundColor: Colors.lightBlueAccent,
          body: LoginPage(),
        ));
  }
}
