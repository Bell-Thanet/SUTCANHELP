import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sutcanhelp/Pages/model/sosList.dart';
import 'package:url_launcher/url_launcher.dart';

class Telephone extends StatefulWidget {
  @override
  _TelephoneState createState() => _TelephoneState();
}

class _TelephoneState extends State<Telephone> {
  @override
  void initState() {
    super.initState();
    readAllTelephone();
  }

  List<SosList> soslists = List();

  Future<void> readAllTelephone() async {
    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference =
        firestore.collection('Telephone_SOS');
    await collectionReference.snapshots().listen((response) {
      List<DocumentSnapshot> snapshots = response.documents;
      try {
        for (var snapshot in snapshots) {
          setState(() {
            SosList sosList = SosList.fromMap(snapshot.data);
            soslists.add(sosList);
          });
        }
      } catch (e) {
        print(e);
      }
    });
  }

  String phonenumber1;

  _launchURL() async {
    var url = 'tel: $phonenumber1';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  showlistview(int index) {
    if (soslists[index].title != null && soslists[index].phonenumber != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 20,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      soslists[index].title,
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      soslists[index].phonenumber,
                      style: TextStyle(fontSize: 23.0),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.phone),
                  color: Colors.green,
                  onPressed: () {
                    setState(() {
                      phonenumber1 = soslists[index].phonenumber;
                    });
                    _launchURL();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      if (soslists[index].title == null) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 20,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'null',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        soslists[index].phonenumber,
                        style: TextStyle(fontSize: 23.0),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.phone),
                    color: Colors.green,
                    onPressed: () {
                      setState(() {
                        phonenumber1 = soslists[index].phonenumber;
                      });
                      _launchURL();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      } else if (soslists[index].phonenumber == null) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 20,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        soslists[index].title,
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        'null',
                        style: TextStyle(fontSize: 23.0),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.phone),
                    color: Colors.green,
                    onPressed: () {
                      setState(() {
                        phonenumber1 = soslists[index].phonenumber;
                      });
                      _launchURL();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'แจ้งเหตุฉุกเฉิน',
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
      backgroundColor: Colors.lightBlueAccent,
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

    // Column(
    //   children: <Widget>[
    //     Center(
    //       child: RaisedButton(
    //         onPressed: _launchURL,
    //         child: Text('Show Flutter homepage'),
    //       ),
    //     ),
    //     ListView.builder(itemBuilder: (BuildContext buildContext, int index) {
    //       return Text(soslists[index].title);
    //     })
    //   ],
    // );
  }
}

/*        */
