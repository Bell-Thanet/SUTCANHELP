import 'package:flutter/material.dart';

import 'Setup/signIn.dart';

void main() => runApp(AppNew());

class AppNew extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SUT CAN HELP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
