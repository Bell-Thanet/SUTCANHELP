import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sutcanhelp/widget/bottomNavigation.dart';
import 'package:sutcanhelp/widget/loading.dart';
import 'package:sutcanhelp/widget/multiSelectChip.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Message {
  String title;
  String body;
  String message;
  Message(title, body, message) {
    this.title = title;
    this.body = body;
    this.message = message;
  }
}

class SosAnimal extends StatefulWidget {
  @override
  _SosAnimalState createState() => _SosAnimalState();
}

class _SosAnimalState extends State<SosAnimal> {
  @override
  void initState() {
    super.initState();

    _goToMe();
    myLocationButton();
    getdata();
    _messages = List<Message>();
    _getToken();
    _configureFirebaseListeners();
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<Message> _messages;

  _getToken() {
    _firebaseMessaging.getToken().then((deviceToken) {
      print("Device Token: $deviceToken");
    });
  }

  _configureFirebaseListeners() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('onMessage: $message');
      _setMessage(message);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('onMessage: $message');
      _setMessage(message);
    }, onResume: (Map<String, dynamic> message) async {
      print('onMessage: $message');
      _setMessage(message);
    });
  }

  _setMessage(Map<String, dynamic> message) {
    final notification = message['notification'];
    final data = message['data'];
    final String title = notification['title'];
    final String body = notification['body'];
    final String mMessage = data['message'];
    setState(() {
      Message m = Message(title, body, message);
      _messages.add(m);
    });
  }

  //*************************** MAP */
  final Set<Marker> _markers = {};
  static const LatLng _center = const LatLng(14.8817767, 102.0185022);
  LatLng _lastMapPosition = _center;
  Completer<GoogleMapController> _controller = Completer();
  String posi1 = '...';
  LocationData currentLocation;
  //******************************** */

  //********************************PHOTO */
  File _image1;
  File _image2;
  File _image3;
  int index = 0;
  //******************************** */

  //******************************** Box and ListAnimal*/
  List<String> reportList = [/*Data Hascode*/];
  List<String> selectedAnimalList = List();
  //******************************** */

  //******************************** DetailText */
  var detail;
  final formKey = GlobalKey<FormState>();
  //*********************************/

  //******************************** ADDdataToDatabase */
  var url1;
  var url2;
  var url3;
  bool loading = false;
  //*********************************/
  //******************************** MAP */
  googlemap() {
    return Column(
      children: <Widget>[
        Container(
          height: 220,
          child: GoogleMap(
            // onCameraMove: _onCameraMove,
            // myLocationButtonEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition:
                CameraPosition(target: _lastMapPosition, zoom: 10),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: _markers,
            onTap: (position) {
              Marker mk1 = Marker(
                markerId: MarkerId('1'),
                position: position,
              );
              setState(() {
                _markers.add(mk1);
                print(position);
                posi1 =
                    LatLng(position.latitude, position.longitude).toString();
                // setPosition(posi1);
              });
              // if(_markers.length < 1){
              //   print("no marker");
              // }
              // print(_markers.first.position);
            },
          ),
        ),
        // myLocationButton()
      ],
    );
  }

  myLocationButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(200, 170, 10, 10),
      child: FloatingActionButton.extended(
        onPressed: _goToMe,
        label: Text('My location'),
        icon: Icon(Icons.room),
        heroTag: null,
      ),
    );
  }

  Future _goToMe() async {
    final GoogleMapController controller = await _controller.future;
    currentLocation = await getCurrentLocation();
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(
        currentLocation.latitude,
        currentLocation.longitude,
      ),
      zoom: 16,
    )));
    _onAddMarkerButtonPressed();
  }

  Future<LocationData> getCurrentLocation() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // Permission denied
      }
      return null;
    }
  }

  _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('1'),
          // markerId: MarkerId(_lastMapPosition.toString()),
          position: LatLng(currentLocation.latitude, currentLocation.longitude),
          infoWindow: InfoWindow(
            title: 'This is a Title',
            snippet: 'This is a snippet',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
      posi1 = LatLng(currentLocation.latitude, currentLocation.longitude)
          .toString();
      print(LatLng(currentLocation.latitude, currentLocation.longitude));
    });
  }

//******************************** */
//********************************ADD PHOTO */
  Widget buttonupdatePhoto() {
    return Container(
      child: IconButton(
        icon: Icon(
          Icons.camera_enhance,
          color: Colors.lightBlue,
        ),
        onPressed: () {
          getImage();
        },
        iconSize: 60.0,
      ),
    );
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    print(image.lengthSync());
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        compressQuality: 30,
        maxHeight: 200,
        maxWidth: 200,
        cropStyle: CropStyle.rectangle,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    setState(() {
      // if (_image1 != null) {
      //   index = 2;
      // } else if (_image1 == null) {
      //   index = 1;
      // } else if (_image2 == null) {
      //   index = 2;
      // } else if (_image2 != null) {
      //   index = 3;
      // } else if (_image3 == null) {
      //   index = 3;
      // }

      // if (_image1 != null) {
      //   index = 2;
      // } else if (_image1 == null) {
      //   index = 1;
      // }
      // if (_image2 == null) {
      //   index = 2;
      // } else if (_image2 != null) {
      //   index = 3;
      // }

      // if (_image1 != null || _image2 != null)
      //   index += 1;
      // else
      //   index = 1;

      if (_image1 == null) {
        index = 1;
      }
      if (_image2 == null && _image1 != null) {
        index = 2;
      }
      if (_image3 == null && _image1 != null && _image2 != null) {
        index = 3;
      }
      switch (index) {
        case 1:
          _image1 = croppedFile;
          print("Impge1 Patn $_image1");
          print("getImage1 $index");
          break;
        case 2:
          _image2 = croppedFile;
          print("Impge2 Patn $_image2");
          print("getImage2 $index");
          break;
        case 3:
          _image3 = croppedFile;
          print("Impge3 Patn $_image3");
          print("getImage3 $index");
          break;
      }
      // _image = croppedFile;
      // print("Impge1 Patn $_image1");
    });
  }

  Widget showPhoto1() {
    if (_image1 == null) {
      return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            // color: Colors.green,
            height: 110,
            width: 110,
          ),
        ),
      );
    } else {
      return Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Stack(
            children: <Widget>[
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.file(
                    _image1,
                    width: 110,
                    height: 110,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 70, bottom: 10),
                child: Container(
                  child: IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _image1 = null;
                        index -= 1;
                        print("showPhoto1 $index");
                      });
                    },
                    iconSize: 30.0,
                  ),
                ),
              ),
            ],
          ));
    }
  }

  Widget showPhoto2() {
    if (_image2 == null) {
      return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            // color: Colors.green,
            height: 110,
            width: 110,
          ),
        ),
      );
    } else {
      return Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.file(
                  _image2,
                  width: 110,
                  height: 110,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 70, bottom: 10),
                child: Container(
                  child: IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _image2 = null;
                        index = 1;
                        print("showPhoto2 $index");
                      });
                    },
                    iconSize: 30.0,
                  ),
                ),
              ),
            ],
          ));
    }
  }

  Widget showPhoto3() {
    if (_image3 == null) {
      return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            // color: Colors.green,
            height: 110,
            width: 110,
          ),
        ),
      );
    } else {
      return Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.file(
                  _image3,
                  width: 110,
                  height: 110,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 70, bottom: 10),
                child: Container(
                  child: IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _image3 = null;
                        index = 2;
                        print("showPhoto2 $index");
                      });
                    },
                    iconSize: 30.0,
                  ),
                ),
              ),
            ],
          ));
    }
  }

//******************************** */
//******************************** Box and ListAnimal*/
  bottomDetailList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: selectedAnimalList.length != 0
                ? Container(
                    color: Colors.black12,
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 70,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: ListView(
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    selectedAnimalList.join(" , "),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                selectedAnimalList = [];
                              });
                            },
                            icon: Icon(Icons.cancel),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    color: Colors.black12,
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 70,
                    child: Center(
                        child: Text(
                      "ชนิดของสัตว์",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    )),
                  )),
        Material(
          borderRadius: BorderRadius.circular(20.0),
          shadowColor: Colors.black54,
          elevation: 5.0,
          child: MaterialButton(
            minWidth: 70.0,
            // minWidth: MediaQuery.of(context).size.width,
            height: 50.0,
            onPressed: () {
              _showSosListDialog();
            },
            // child: Text(
            //   'AA',
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //       color: Colors.white,
            //       fontSize: 20.0,
            //       fontWeight: FontWeight.bold),
            // ),
            child: Icon(
              Icons.pets,
              color: Colors.white,
              size: 25,
            ),
          ),
          color: Colors.green[700],
        ),
      ],
    );
  }

  _showSosListDialog() {
    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       //Here we will build the content of the dialog
    //       return AlertDialog(
    //         title: Text("Report Video"),
    //         content: MultiSelectChip(
    //           reportList,
    //           onSelectionChanged: (selectedList) {
    //             setState(() {
    //               selectedSOSList = selectedList;
    //             });
    //           },
    //         ),
    //         actions: <Widget>[
    //           FlatButton(
    //             child: Text("Report"),
    //             onPressed: () => Navigator.of(context).pop(),
    //           )
    //         ],
    //       );
    //     });
    return Alert(
        context: context,
        title: 'ชนิดของสัตว์',
        content: MultiSelectChip(
          reportList,
          onSelectionChanged: (selectedList) {
            setState(() {
              selectedAnimalList = selectedList;
            });
          },
        ),
        buttons: [
          DialogButton(
            color: Colors.lime,
            child: Text(
              'OK',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          DialogButton(
            color: Colors.redAccent,
            child: Text(
              'Cancle',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            onPressed: () {
              if (selectedAnimalList != []) {
                setState(() {
                  selectedAnimalList = [];
                });
              }
              // setState(() {
              //   selectedSOSList = [];
              // });
              Navigator.of(context).pop();
            },
          )
        ]).show();
  }

  Future<void> getdata() async {
    setState(() {
      final DocumentReference documentReference =
          Firestore.instance.document('AnimalList/animalList');
      documentReference.get().then((datasnapshot) {
        if (datasnapshot.exists) {
          setState(() {
            for (var v in datasnapshot.data.keys) {
              // print('$v');
              reportList.add(datasnapshot.data['$v'].toString());
            }
          });
        }
      });
    });
  }
  //******************************** */

  //******************************** DetailText */

  Widget detailText() {
    return TextFormField(
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: "รายละเอียด",
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
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
        detail = d;
      },
    );
  }

  //******************************** */

  //******************************** ADDdataToDatabase */
  addMapTodatabase() {
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

          if (selectedAnimalList.length == 0 || posi1 == '...') {
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
            formKey.currentState.save();
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
        Firestore.instance.collection('AnimalSOS').document();
    print(documentReference.documentID);
    String documentID = documentReference.documentID;
    uploadPhoto(context, documentID);
    Map<String, String> data = <String, String>{
      "User": userid,
      "Position": posi1,
      // "ระดับอาการ": selectedsos,
      "Detail": detail,
      "Animal": selectedAnimalList.join(","),
      "Timestamp": DateTime.now().toString(),
    };

    documentReference.setData(data).whenComplete(() {
      print(
          "User: $userid \t Position: $posi1  \t Detail $detail \t Animal $selectedAnimalList");

      // print(
      //     "Email: $emailString /t Password: $passString /t Name: $nameString /t URL: null ");
    }).catchError((e) => print(e));
  }

  Future<void> uploadPhoto(BuildContext context, String documentIDSOS) async {
    // String filName = basename(_image.path);
    print("uploadPhoto index = $index");
    for (int i = 1; i <= 3; i++) {
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('Animal')
          .child(documentIDSOS + "_" + i.toString());
      if (i == 1 && _image1 != null) {
        print(_image1.lengthSync());
        StorageUploadTask storageUploadTask =
            firebaseStorageRef.putFile(_image1);
        var downUrl1 =
            await (await storageUploadTask.onComplete).ref.getDownloadURL();

        url1 = downUrl1.toString();
        print("Download URL1 $url1");
      } else if (i == 2 && _image2 != null) {
        print(_image2.lengthSync());
        StorageUploadTask storageUploadTask =
            firebaseStorageRef.putFile(_image2);
        var downUrl2 =
            await (await storageUploadTask.onComplete).ref.getDownloadURL();

        url2 = downUrl2.toString();
        print("Download URL2 $url2");
      } else if (i == 3 && _image3 != null) {
        print(_image3.lengthSync());
        StorageUploadTask storageUploadTask =
            firebaseStorageRef.putFile(_image3);
        var downUrl3 =
            await (await storageUploadTask.onComplete).ref.getDownloadURL();

        url3 = downUrl3.toString();
        print("Download URL3 $url3");
        print('\n');
      }
    }
    setURLImageToSOS(url1, url2, url3, documentIDSOS);
  }

  Future<void> setURLImageToSOS(
      String url1, String url2, String url3, String documentIDSOS) async {
    final DocumentReference documentReference =
        Firestore.instance.document('AnimalSOS/$documentIDSOS');
    // Firestore.instance.document('Users');
    Map<String, String> data = <String, String>{
      "ImageAnimal_1": url1,
      "ImageAnimal_2": url2,
      "ImageAnimal_3": url3
    };
    documentReference.updateData(data).whenComplete(() {
      setState(() {
        print(
            'documentIDSOS $documentIDSOS \t Update URL1 image To $url1 and Sucess');
        print(
            'documentIDSOS $documentIDSOS \t Update URL2 image To $url2 and Sucess');
        print(
            'documentIDSOS $documentIDSOS \t Update URL3 image To $url3 and Sucess');
        loading = false;

        Alert(
            context: context,
            title: 'แจ้งSOSสำเร็จ',
            style: alertStyle,
            buttons: [
              DialogButton(
                child: Text(
                  'OK',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  MaterialPageRoute materialPageRoute = MaterialPageRoute(
                      builder: (BuildContext context) => BottomNavigation());
                  Navigator.of(context).pushAndRemoveUntil(
                      materialPageRoute, (Route<dynamic> route) => false);
                },
              ),
            ]).show();
      });
    }).catchError((e) => print(e));
  }

  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    animationDuration: Duration(milliseconds: 300),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      side: BorderSide(
        color: Colors.black,
      ),
    ),
    titleStyle: TextStyle(
      color: Colors.black,
    ),
  );

  //******************************** */

  @override
  Widget build(BuildContext context) {
    var divw = MediaQuery.of(context).size.width;
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Center(child: Text("แจ้งจับสัตว์")),
            ),
            backgroundColor: Colors.white,
            body: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 220,
                      child: Stack(
                        children: <Widget>[
                          googlemap(),
                          myLocationButton(),
                        ],
                      ),
                    )
                  ],
                ),
                Expanded(
                    child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          // color: Colors.black54,
                          padding: EdgeInsets.all(5),
                          // margin: EdgeInsets.all(10),
                          // height: 120,

                          child: Row(
                            children: <Widget>[
                              buttonupdatePhoto(),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Container(
                                  // margin: EdgeInsets.all(20),
                                  color: Colors.lightBlue[100],
                                  height: 110,
                                  width: divw / 1.4,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: <Widget>[
                                            showPhoto1(),
                                            showPhoto2(),
                                            showPhoto3(),
                                          ],
                                        ),
                                      )
                                      // Text('Photo')
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 15.0,
                                ),
                                bottomDetailList(),
                                SizedBox(
                                  height: 15.0,
                                ),
                                // dropdoweBox(),
                                // SizedBox(
                                //   height: 15.0,
                                // ),
                                detailText(),
                                SizedBox(height: 30),
                                addMapTodatabase(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ))
              ],
            ),
          );
  }
}
