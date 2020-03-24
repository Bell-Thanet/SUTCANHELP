import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sutcanhelp/Pages/model/learnbooksosList.dart';

// class Message {
//   String title;
//   String body;
//   String message;
//   Message(title, body, message) {
//     this.title = title;
//     this.body = body;
//     this.message = message;
//   }
// }

class ListLearnBook extends StatefulWidget {
  @override
  _ListLearnBookState createState() => _ListLearnBookState();
}

class _ListLearnBookState extends State<ListLearnBook> {
  @override
  void initState() {
    super.initState();
    readAllLearnBookSOS();
    // findDisplayName();
    // getdata();
    // showDrawer();
    // showHeader();
    // _messages = List<Message>();
    // _getToken();
    // _configureFirebaseListeners();
  }

  List<LearnBookSOS> soslists = List();

  Future<void> readAllLearnBookSOS() async {
    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference =
        firestore.collection("LearnBookSOS");
    await collectionReference.snapshots().listen((response) {
      List<DocumentSnapshot> snapshots = response.documents;
      try {
        for (var snapshot in snapshots) {
          setState(() {
            LearnBookSOS sosList = LearnBookSOS.fromMap(snapshot.data);
            soslists.add(sosList);
          });
        }
      } catch (e) {
        print(e);
      }
    });
  }

  showlistview(int index) {
    if (soslists[index].location != null &&
        soslists[index].subject != null &&
        soslists[index].date != null &&
        soslists[index].time != null) {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: Card(
          elevation: 20,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Text(
                  soslists[index].subject,
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(width: 10),
                Text(soslists[index].location),
                SizedBox(width: 10),
                Text(soslists[index].time+' / '+soslists[index].date),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
  // showlistview(int index) {
  //   if (soslists[index].title != null && soslists[index].phonenumber != null) {
  //     return Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Card(
  //         elevation: 20,
  //         child: Padding(
  //           padding: EdgeInsets.all(10.0),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: <Widget>[
  //               Column(
  //                 children: <Widget>[
  //                   Text(
  //                     soslists[index].title,
  //                     style: TextStyle(fontSize: 20.0),
  //                   ),
  //                   SizedBox(
  //                     height: 5.0,
  //                   ),
  //                   Text(
  //                     soslists[index].phonenumber,
  //                     style: TextStyle(fontSize: 23.0),
  //                   ),
  //                 ],
  //               ),
  //               IconButton(
  //                 icon: Icon(Icons.phone),
  //                 color: Colors.green,
  //                 onPressed: () {
  //                   setState(() {
  //                     phonenumber1 = soslists[index].phonenumber;
  //                   });
  //                   _launchURL();
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   } else {
  //     if (soslists[index].title == null) {
  //       return Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Card(
  //           elevation: 20,
  //           child: Padding(
  //             padding: EdgeInsets.all(10.0),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: <Widget>[
  //                 Column(
  //                   children: <Widget>[
  //                     Text(
  //                       'null',
  //                       style: TextStyle(fontSize: 20.0),
  //                     ),
  //                     SizedBox(
  //                       height: 5.0,
  //                     ),
  //                     Text(
  //                       soslists[index].phonenumber,
  //                       style: TextStyle(fontSize: 23.0),
  //                     ),
  //                   ],
  //                 ),
  //                 IconButton(
  //                   icon: Icon(Icons.phone),
  //                   color: Colors.green,
  //                   onPressed: () {
  //                     setState(() {
  //                       phonenumber1 = soslists[index].phonenumber;
  //                     });
  //                     _launchURL();
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     } else if (soslists[index].phonenumber == null) {
  //       return Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Card(
  //           elevation: 20,
  //           child: Padding(
  //             padding: EdgeInsets.all(10.0),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: <Widget>[
  //                 Column(
  //                   children: <Widget>[
  //                     Text(
  //                       soslists[index].title,
  //                       style: TextStyle(fontSize: 20.0),
  //                     ),
  //                     SizedBox(
  //                       height: 5.0,
  //                     ),
  //                     Text(
  //                       'null',
  //                       style: TextStyle(fontSize: 23.0),
  //                     ),
  //                   ],
  //                 ),
  //                 IconButton(
  //                   icon: Icon(Icons.phone),
  //                   color: Colors.green,
  //                   onPressed: () {
  //                     setState(() {
  //                       phonenumber1 = soslists[index].phonenumber;
  //                     });
  //                     _launchURL();
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: Center(
            child: Text(
          'แจ้งเตือนการติว',
          style: TextStyle(fontSize: 25),
        )),
      ),
      body: Container(
        margin: MediaQuery.of(context).padding,
        child: ListView.builder(
            itemCount: soslists.length,
            itemBuilder: (BuildContext buildContext, int index) {
              return showlistview(index);
              // Row(
              //   children: <Widget>[
              //     ,
              //     Divider(height: 30, color: Colors.black),
              //   ],
              // );
            }),
      ),
    );
  }
}

// final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
// List<Message> _messages;
// _getToken() {
//   _firebaseMessaging.getToken().then((deviceToken) {
//     print("Device Token: $deviceToken");
//   });
// }

// _configureFirebaseListeners() {
//   _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//     print('onMessage: $message');
//     _setMessage(message);
//   }, onLaunch: (Map<String, dynamic> message) async {
//     print('onMessage: $message');
//     _setMessage(message);
//   }, onResume: (Map<String, dynamic> message) async {
//     print('onMessage: $message');
//     _setMessage(message);
//   });
// }

// _setMessage(Map<String, dynamic> message) {
//   final notification = message['notification'];
//   final data = message['data'];
//   final String title = notification['title'];
//   final String body = notification['body'];
//   final String mMessage = data['message'];
//   setState(() {
//     Message m = Message(title, body, message);
//     _messages.add(m);
//   });
// }
