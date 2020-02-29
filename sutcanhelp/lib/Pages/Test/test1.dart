// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:sutcanhelp/Pages/Test/wit.dart';

// class Test1 extends StatefulWidget {
//   @override
//   _Test1State createState() => _Test1State();
// }

// class _Test1State extends State<Test1> {
// FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
//   @override
//   void initState() {
//     super.initState();
//     getdata();
 
//   }

//   List<String> reportList = [
//     // "Not relevant",
//     // "Illegal",
//     // "Spam",
//     // "Offensive",
//     // "Uncivil"
//   ];

//   List<String> selectedReportList = List();

//    Future<void> getdata() async {
//     setState(() {
    
//       final DocumentReference documentReference =
//           Firestore.instance.document('SosList/soslist');
//       documentReference.get().then((datasnapshot) {
//         if (datasnapshot.exists) {
//           setState(() {
//            for (var v in datasnapshot.data.keys) {
//              print('$v');
//              reportList.add(datasnapshot.data['$v'].toString());
//            }
//           });
//         }
//       });
//     });
//   }

  

//   _showReportDialog() {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           //Here we will build the content of the dialog
//           return AlertDialog(
//             title: Text("Report Video"),
//             content: MultiSelectChip(
//               reportList,
//               onSelectionChanged: (selectedList) {
//                 setState(() {
//                   selectedReportList = selectedList;
//                 });
//               },
//             ),
//             actions: <Widget>[
//               FlatButton(
//                 child: Text("Report"),
//                 onPressed: () => Navigator.of(context).pop(),
//               )
//             ],
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('asdas'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             RaisedButton(
//               child: Text("Report"),
//               onPressed: () => _showReportDialog(),
//             ),
//             Text(selectedReportList.join(" , ")),
//           ],
//         ),
//       ),
//     );
//   }
// }
