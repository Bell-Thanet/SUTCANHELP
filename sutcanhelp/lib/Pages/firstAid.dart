import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sutcanhelp/Pages/model/firstaid_model.dart';

class FirstAid extends StatefulWidget {
  @override
  _FirstAidState createState() => _FirstAidState();
}

class _FirstAidState extends State<FirstAid> {
  @override
  void initState() {
    super.initState();
    readAllTelephone();
  }

  List<FirstAid1> soslists = List();
  int a;
  List<String> reportList = [/*Data Hascode*/];

  Future<void> readAllTelephone() async {
    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference = firestore.collection('First_Aid');
    await collectionReference.snapshots().listen((response) {
      List<DocumentSnapshot> snapshots = response.documents;

      for (var snapshot in snapshots) {
        setState(() {
          FirstAid1 sosList = FirstAid1.fromMap(snapshot.data);
          soslists.add(sosList);
          for (int i = 1; i <= snapshot.data.length - 1; i++)
            reportList.add(snapshot.data['$i']);
        });
      }
      // for (var snapshot in snapshots) {
      //   setState(() {
      //     First_Aid sosList = First_Aid.fromMap(snapshot.data);
      //     soslists.add(sosList);
      //   });
      // }
      // setState(() {
      //   for (int i = 0; i <= soslists.length; i++) {
      //     a = soslists[i].number.length;
      //     var b = soslists.length;
      //     print('************************************************$a');
      //     print('************************************************$b');
      //   }
      // });
    });
  }

  // Widget aa() {
  //   for (int i = 0; i < 1; i++) {
  //     for (int j = 0; j < 3; j++) {
  //       return Column(
  //         children: <Widget>[
  //           Text(
  //             'i',
  //             style: TextStyle(fontSize: 20),
  //           ),
  //           ListView.builder(
  //               itemCount: j,
  //               itemBuilder: (BuildContext buildContext, int index) {
  //                 return Text('index');
  //               })
  //         ],
  //       );
  //     }
  //   }
  // }
  showlistview(int index, int index1) {
    return Row(
      children: <Widget>[
        Text(soslists[index].title),
        Text(soslists[index].number[index1])
      ],
    );
  }

  // asd(int j) {
  //   ListView.builder(
  //       scrollDirection: Axis.vertical,
  //       itemCount: 10,
  //       itemBuilder: (BuildContext ctx, int colIdx) {});

  //   for (int r = 0; r < 3; r++) {
  //     print(r);
  //     return Text(soslists[j].number[r]);
  //   }
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       backgroundColor: Colors.lightBlueAccent,
  //       appBar: AppBar(
  //         title: Center(
  //           child: Text('ประถมพยาบาล'),
  //         ),
  //       ),
  //       body: Column(
  //         children: <Widget>[
  //           Container(
  //             child: Expanded(
  //               child: new ListView.builder(
  //                 itemCount: soslists.length,
  //                 shrinkWrap: true,
  //                 itemBuilder: (BuildContext ctx, int rowIdx) {
  //                   return Text(soslists[rowIdx].title);

  //                   // ListView.builder(
  //                   //   scrollDirection: Axis.vertical,
  //                   //   shrinkWrap: true,
  //                   //   itemCount: soslists[rowIdx].number.length,
  //                   //   itemBuilder: (BuildContext ctx, int colIdx) {
  //                   //     return ListTile(
  //                   //       title: Text(soslists[rowIdx].title),
  //                   //       subtitle: Text(soslists[rowIdx].number[colIdx]),
  //                   //     );

  //                   // showlistview(rowIdx, colIdx);
  //                   // return Column(
  //                   //   children: <Widget>[Text(soslists[rowIdx].number[colIdx])],
  //                   // );
  //                   // },
  //                   // );
  //                 },
  //               ),
  //             ),
  //           ),
  //           Container(
  //             child: Expanded(
  //               child: new ListView.builder(
  //                 itemCount: soslists.length,
  //                 shrinkWrap: true,
  //                 itemBuilder: (BuildContext ctx, int rowIdx) {
  //                   return new ListView.builder(
  //                     scrollDirection: Axis.vertical,
  //                     shrinkWrap: true,
  //                     itemCount: soslists[rowIdx].number.length,
  //                     itemBuilder: (BuildContext ctx1, int colIdx){

  //                       return Row(
  //                         children: <Widget>[
  //                           Text(soslists[rowIdx].number[colIdx]),
  //                           Text(soslists[rowIdx].number[colIdx]),
  //                         ],
  //                       );
  //                     }
  //                   );
  //                 },
  //               ),
  //             ),
  //           ),
  //         ],
  //       ));
  // }

  // Widget _buildBody() {
  //   return new ListView.builder(
  //     itemCount: soslists.length,
  //     shrinkWrap: true,
  //     itemBuilder: (BuildContext ctx, int rowIdx) {
  //       return new ListView.builder(
  //         scrollDirection: Axis.vertical,
  //         shrinkWrap: true,
  //         itemCount: soslists[rowIdx].number.length,
  //         itemBuilder: (BuildContext ctx, int colIdx) {
  //           // return Text('$rowIdx - $colIdx');
  //           return Column(
  //             children: <Widget>[
  //               Text(soslists[rowIdx].title),
  //               IconButton(
  //                   icon: Icon(Icons.access_alarms),
  //                   onPressed: () {
  //                     setState(() {
  //                       e = rowIdx;
  //                     });
  //                   })
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  //   // return Text('data');
  // }

  // int e;
  Widget _buildBody() {
    return soslists != null
        ? new ListView.builder(
            itemCount: soslists.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext ctx, int rowIdx) {
              return soslists[rowIdx].title != null
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.20,
                        width: MediaQuery.of(context).size.width * 0.5,
                        // child: FittedBox(
                        child: Material(
                          // color: Colors.white,
                          elevation: 14.0,
                          borderRadius: BorderRadius.circular(24.0),
                          shadowColor: Colors.black,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                // height:
                                //     MediaQuery.of(context).size.height * 0.2,

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      soslists[rowIdx].title,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    FlatButton(
                                      // color: Colors.blue,
                                      textColor: Colors.black54,
                                      // disabledColor: Colors.grey,
                                      // disabledTextColor: Colors.black,
                                      // padding: EdgeInsets.all(8.0),
                                      // splashColor: Colors.blueAccent,
                                      onPressed: () {
                                        // setState(() {
                                        //   // e = rowIdx;
                                        //   // print(e);

                                        // });
                                        showModalBottom(context, rowIdx);
                                      },
                                      child: Text(
                                        "ดูวิธีประถมพยาบาล",
                                        style: TextStyle(fontSize: 15.0),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.20,
                                width: MediaQuery.of(context).size.width * .4,
                                child: CachedNetworkImage(
                                  imageUrl: soslists[rowIdx].image,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),

                                // ClipRRect(
                                //     borderRadius: BorderRadius.circular(24.0),
                                //     child: Image(
                                //       fit: BoxFit.cover,
                                //       alignment: Alignment.center,
                                //       image:
                                //           NetworkImage(soslists[rowIdx].image),
                                //     )),
                              ),
                            ],
                          ),
                        ),
                        // ),
                      ),
                    )
                  : Container();
            },
          )
        : Container();
    // return Text('data');
  }

//****************************เอา */
  // Widget _buildBody() {
  //   return soslists != null
  //       ? new ListView.builder(
  //           itemCount: soslists.length,
  //           shrinkWrap: true,
  //           itemBuilder: (BuildContext ctx, int rowIdx) {
  //             return soslists[rowIdx].title != null
  //                 ? Row(
  //                     children: <Widget>[
  //                       Text(soslists[rowIdx].title),
  //                       IconButton(
  //                           icon: Icon(Icons.access_alarms),
  //                           onPressed: () {
  //                             setState(() {
  //                               e = rowIdx;
  //                               print(e);
  //                               showModalBottom(context);
  //                             });
  //                           })
  //                     ],
  //                   )
  //                 : Column();
  //           },
  //         )
  //       : Column();
  //   // return Text('data');
  // }

  int p = 1;
  showModalBottom(context, e) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return e != null && soslists[e].number.length != 0
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  // height: 200,
                  color: Colors.blue[200],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'ปฐมพยาบาลเบื้องต้น',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.black,
                                  size: 25.0,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                })
                          ],
                        ),
                        Expanded(
                            child: ListView.builder(
                                itemCount: soslists[e].number.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctx, int rowIdx) {
                                  return soslists[e].number[rowIdx] != null
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                                "●  " +
                                                    soslists[e].number[rowIdx],
                                                style: TextStyle(
                                                  fontSize: 17.0,
                                                ))

                                            // IconButton(
                                            //     icon: Icon(Icons.access_alarms),
                                            //     onPressed: () {
                                            //       setState(() {
                                            //         e = rowIdx;
                                            //         print(e);
                                            //       });
                                            //     })
                                          ],
                                        )
                                      : Container();
                                }))
                      ],
                    ),
                  ),
                )
              : Container();
        });
  }

  // Widget _buildBody1() {
  //   return e != null && soslists[e].number.length != 0
  //       ? Card(
  //           child: ListView.builder(
  //             itemCount: soslists[e].number.length,
  //             shrinkWrap: true,
  //             itemBuilder: (BuildContext ctx, int rowIdx) {
  //               return soslists[e].number[rowIdx] != null
  //                   ? Row(
  //                       children: <Widget>[
  //                         Text(soslists[e].number[rowIdx]),
  //                         // IconButton(
  //                         //     icon: Icon(Icons.access_alarms),
  //                         //     onPressed: () {
  //                         //       setState(() {
  //                         //         e = rowIdx;
  //                         //         print(e);
  //                         //       });
  //                         //     })
  //                       ],
  //                     )
  //                   : Column();
  //             },
  //           ),
  //         )
  //       : Column();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlueAccent,
        appBar: AppBar(
          title: Center(
            child: Text("วิธีประถมพยาบาล", style: TextStyle(fontSize: 23)),
          ),
        ),
        body: _buildBody()
        //  Wrap(
        //   children: <Widget>[
        //     Expanded(
        //         child: ListView(
        //       children: <Widget>[
        //         Image.network(
        //             'https://firebasestorage.googleapis.com/v0/b/sutcanhelp.appspot.com/o/FirstAid%2FTop-Cat-Character.gif?alt=media&token=2108a2e7-276c-4569-85c8-149df8fdd052'),
        //         Image.network(
        //             'https://firebasestorage.googleapis.com/v0/b/sutcanhelp.appspot.com/o/FirstAid%2FTop-Cat-Character.gif?alt=media&token=2108a2e7-276c-4569-85c8-149df8fdd052'),
        //         Image.network(
        //             'https://firebasestorage.googleapis.com/v0/b/sutcanhelp.appspot.com/o/FirstAid%2FTop-Cat-Character.gif?alt=media&token=2108a2e7-276c-4569-85c8-149df8fdd052'),
        //       ],
        //     ))
        //   ],
        // )

        // ListView.builder(
        //     itemCount: soslists.length,
        //     itemBuilder: (BuildContext context, int a) {
        //       return Image.network(soslists[a].image.toString());
        //     })

        // Wrap(
        //   children: <Widget>[
        //     ListView.builder(
        //         itemCount: soslists.length,
        //         itemBuilder: (BuildContext context, int a) {
        //           return Image.network(soslists[a].image.toString());
        //         })
        //   ],
        // )

        //     Column(
        //   children: <Widget>[
        //     _buildBody(),
        //     // _buildBody1(),
        //     // Text(soslists[1].title)
        //   ],
        // ),
        );
  }
}
