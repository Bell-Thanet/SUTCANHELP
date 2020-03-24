import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sutcanhelp/widget/bottomNavigation.dart';
import 'package:sutcanhelp/widget/loading.dart';

class LearnBook extends StatefulWidget {
  @override
  _LearnBookState createState() => _LearnBookState();
}

class _LearnBookState extends State<LearnBook> {
  bool loading = false;
  //******************************** DetailText */
  var location;
  var subject;
  var time;
  var date;
  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  final formKey = GlobalKey<FormState>();
  //*********************************/

  //******************************** DetailText */

  Widget locationText() {
    return TextFormField(
      decoration: InputDecoration(
        // fillColor: Colors.lightBlue[100],
        filled: true,
        hintText: "สถานที่ติว",
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        prefixIcon: Icon(
          Icons.room,
          color: Colors.blue[600],
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please Fill Your Name in the Blank';
        } else {
          return null;
        }
      },
      onSaved: (String l) {
        location = l;
      },
    );
  }

  Widget subjectText() {
    return TextFormField(
      decoration: InputDecoration(
        // fillColor: Colors.lightBlue[100],
        filled: true,
        hintText: "วิชาที่ต้องการติว",
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        prefixIcon: Icon(
          Icons.book,
          color: Colors.blue[600],
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please Fill Your Name in the Blank';
        } else {
          return null;
        }
      },
      onSaved: (String s) {
        subject = s;
      },
    );
  }

  Widget timeText() {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        // fillColor: Colors.lightBlue[100],
        filled: true,
        hintText: '${_time.hour}:${_time.minute}',
        // hintText: timeFormat.format(_time),
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        suffixIcon: IconButton(
          color: Colors.blue[600],
          icon: Icon(Icons.access_time),
          onPressed: () {
            print('Time');
            _selectTime(context);
          },
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please Fill Your Name in the Blank';
        } else {
          return null;
        }
      },
      onSaved: (String t) {
        time = '${_time.hour}:${_time.minute}';
      },
    );
  }

  Widget dateText() {
    return TextFormField(
      // enabled: false,
      readOnly: true,
      decoration: InputDecoration(
        // fillColor: Colors.lightBlue[100],

        filled: true,
        // hintText: _date.toString(),
        hintText: '${dateFormat.format(_date)}',
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),

        suffixIcon: IconButton(
          color: Colors.blue[600],
          icon: Icon(Icons.date_range),
          onPressed: () {
            print('Date');
            _selectdate(context);
          },
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please Fill Your Name in the Blank';
        } else {
          return null;
        }
      },
      onSaved: (String d) {
        date = '${dateFormat.format(_date)}';
      },
    );
  }

  Future<Null> _selectdate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(seconds: 1)),
      firstDate: DateTime.now(),
      lastDate: new DateTime(2100),
    );
    if (picked != null && picked != _date) {
      // print('Date select: ${_date.toString()}');
      setState(() {
        _date = picked;
        print("${dateFormat.format(_date)}");
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time) {
      // print('Date select: ${_date.toString()}');
      setState(() {
        _time = picked;
        print('${_time.hour}:${_time.minute}');
      });
    }
  }

  //******************************** */

  //******************************** ADDdataToDatabase */
  addDataTodatabase() {
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      shadowColor: Colors.black54,
      elevation: 5.0,
      child: MaterialButton(
        minWidth: 300.0,
        // minWidth: MediaQuery.of(context).size.width,
        height: 50.0,
        onPressed: () {
          // if (selectedsos != null) {
          //   formKey.currentState.save();
          //   // uploadPhoto(context);
          //   database();
          // } else {
          //   print("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ");
          // }

          formKey.currentState.save();
          print("$subject  +++++++++ $location");
          if (subject.toString().isEmpty ||
              location.toString().isEmpty ||
              subject == null ||
              location == null) {
            Alert(
                context: context,
                title: 'ใส่ข้อมูลไม่ครบ',
                //  desc: message,
                type: AlertType.error,
                buttons: [
                  DialogButton(
                    child: Text(
                      'OK',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ]).show();
          } else {
            Alert(context: context, title: 'ต้องการส่งคำขอSOS หรือไม่',
                //  desc: message,
                // type: AlertType.error,
                buttons: [
                  DialogButton(
                    child: Text(
                      'OK',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        loading = true;
                      });
                      database();
                    },
                    color: Colors.green,
                  ),
                  DialogButton(
                    child: Text(
                      'Cancle',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    color: Colors.red,
                    onPressed: () {
                      Navigator.pop(context);
                      print('XXXXXXXXXXXXXXXXXXX');
                    },
                  ),
                ]).show();
            // database();
            // print('XXXXXXXXXXXXXXXXXXX');
          }
        },
        child: Text('SOS',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.bold)),
      ),
      color: Colors.redAccent[700],
    );
  }

  Future<void> database() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var userid = user.uid.toString();

    final DocumentReference documentReference =
        // Firestore.instance.collection('Users').document(userid);
        Firestore.instance.collection('LearnBookSOS').document();
    // print(documentReference.documentID);
    // String documentID = documentReference.documentID;
    // uploadPhoto(context, documentID);
    Map<String, String> data = <String, String>{
      "User": userid,
      "Subject": subject,
      "Location": location,
      "Time": time,
      "Date": date,
      // "Position": posi1,
      // "ระดับอาการ": selectedsos,
      // "Detail": detail,
    };

    documentReference.setData(data).whenComplete(() {
      print("User: $userid \t Subject: $subject  \t Location $location \t Time $time \t Date $date");

      // print(
      //     "Email: $emailString /t Password: $passString /t Name: $nameString /t URL: null ");
    }).catchError((e) => print(e));

    setState(() {
      loading = false;
      MaterialPageRoute materialPageRoute = MaterialPageRoute(
          builder: (BuildContext context) => BottomNavigation());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    });
  }

  //******************************** */

  @override
  Widget build(BuildContext context) {
    var divw = MediaQuery.of(context).size.width;
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Center(
                child: Text('ติวหนังสือ'),
              ),
            ),
            body: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: divw / 2,
                        height: divw / 2,
                        child: Center(
                          child: IconShadowWidget(
                            Icon(
                              Icons.chrome_reader_mode,
                              size: divw / 2,
                              color: Colors.lightBlueAccent,
                            ),
                            shadowColor: Colors.black,
                            showShadow: true,
                          ),
                          // Icon(
                          //   Icons.chrome_reader_mode,
                          //   size: divw / 2,
                          //   color: Colors.lightBlueAccent[700],
                          // ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 15.0),
                            subjectText(),
                            SizedBox(height: 30),
                            locationText(),
                            SizedBox(height: 30),
                            timeText(),
                            SizedBox(height: 30),
                            dateText(),
                            addDataTodatabase(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ));
  }
}
