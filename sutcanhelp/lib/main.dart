// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:sutcanhelp/Pages/home.dart';

// void main() => runApp(Appnew());

// class Appnew extends StatefulWidget {
//   @override
//   _AppnewState createState() => _AppnewState();
// }

// class _AppnewState extends State<Appnew> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(child: Text('aa'),),
//     );
//   }
// }
// // class AppNew extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //         title: 'SUT CAN HELP',
// //         color: Colors.lightBlueAccent,
// //         theme: ThemeData(
// //           primarySwatch: Colors.blue,
// //         ),
// //         home: LoginPage());
// //   }
// // }

import 'package:flutter/material.dart';
import 'package:sutcanhelp/Pages/pageone.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SUT CAN HELP',
      color: Colors.lightBlueAccent,
      home: Pageone(),
      
    );
  }
}
