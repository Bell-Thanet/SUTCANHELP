import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'dart:async';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new MapPage1(),
  ));
}

class MapPage1 extends StatefulWidget {
  @override
  _MapPage1State createState() => new _MapPage1State();
}

class _MapPage1State extends State<MapPage1> {
  final Set<Marker> _markers = {};
  String posi1 = '...';
  LatLng po;

  @override
  void initState() {
    super.initState();
    // getCurrentLocation();
    _goToMe();
    myLocationButton();
  }

  LocationData currentLocation;
  Completer<GoogleMapController> _controller = Completer();
  final formKey = GlobalKey<FormState>();
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

  static const LatLng _center = const LatLng(14.8817767, 102.0185022);
  LatLng _lastMapPosition = _center;

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

  // Future _goToSuwannabhumiAirport() async {
  //   final GoogleMapController controller = await _controller.future;
  //   currentLocation = await getCurrentLocation();
  //   controller
  //       .animateCamera(CameraUpdate.newLatLng(LatLng(13.6900043, 100.7479237)));
  // }

  // Future _zoomOutToBangkok() async {
  //   final GoogleMapController controller = await _controller.future;
  //   currentLocation = await getCurrentLocation();
  //   controller.animateCamera(
  //       CameraUpdate.newLatLngZoom(LatLng(13.6846021, 100.5883304), 10));
  // }

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

  // Widget bbb() {
  //   return FloatingActionButton(
  //       // onPressed: _onAddMarkerButtonPressed,
  //       onPressed: () {
  //         setState(() {
  //           print(po);
  //         });
  //       },
  //       materialTapTargetSize: MaterialTapTargetSize.padded,
  //       backgroundColor: Colors.blue,
  //       child: Icon(
  //         Icons.add_location,
  //         size: 36.0,
  //       ));
  // }

//bugนะ*************************//** */
  // _onCameraMove(CameraPosition position) {
  //   _lastMapPosition = position.target;
  // }

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
                setPosition(posi1);
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
        icon: Icon(Icons.near_me),
        heroTag: null,
      ),
    );
  }

  // addMapTodatabase() {
  //   return Center(
  //     child: FloatingActionButton.extended(
  //       onPressed: () {
  //         database();
  //       },
  //       label: Text('SOS'),
  //       heroTag: null,
  //       backgroundColor: Colors.red,

  //     ),
  //   );
  // }
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
          if (selectedsos != null) {
            formKey.currentState.save();
            database();
          } else {
            print("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ");
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

  // void database(){
  //   return print("เตรียมเข้าdatabase  $po");
  // }

  Future<void> database() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var userid = user.uid.toString();

    final DocumentReference documentReference =
        // Firestore.instance.collection('Users').document(userid);
        Firestore.instance.collection('SOS').document();
    print(documentReference.documentID);
    Map<String, String> data = <String, String>{
      "User": userid,
      "Position": posi1,
      "อาการ": selectedsos,
      "Detail": detail,
    };

    documentReference.setData(data).whenComplete(() {
      print(
          "User: $userid /t Position: $posi1 /t อาการ $selectedsos /t Detail $detail");

      // print(
      //     "Email: $emailString /t Password: $passString /t Name: $nameString /t URL: null ");
    }).catchError((e) => print(e));
  }

  List<String> _datalist = <String>[
    'เบา',
    'หนัก',
  ];

  var selectedsos;
  var detail;

  Widget dropdoweBox() {
    return DropdownButton(
      items: _datalist
          .map((value) => DropdownMenuItem(
                child: Center(
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                value: value,
              ))
          .toList(),
      onChanged: (selected) {
        setState(() {
          selectedsos = selected;
        });
      },
      value: selectedsos,
      isExpanded: true,
      hint: Text('อาการ'),
      style: TextStyle(color: Colors.black, fontSize: 20.0),
    );
  }

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

  File _image1;
  File _image2;
  int index = 0;

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
      index += 1;
      switch (index) {
        case 1:
          _image1 = croppedFile;
          print("Impge1 Patn $_image1");
          break;
        case 2:
          _image2 = croppedFile;
          print("Impge2 Patn $_image2");
          break;
      }
      // _image = croppedFile;
      // print("Impge1 Patn $_image1");
    });
  }

  // Widget selectPhoto(){
  //   if(index==1){
  //     return showPhoto1();
  //   }else if(index==2){
  //     return showPhoto1() showPhoto2();
  //   }
  // }

  Widget showPhoto1() {
    if (_image1 != null && (index == 1 || index == 2)) {
      return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.file(
            _image1,
            width: 110,
            height: 110,
          ),
        ),
      );
    } else {
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
    }
  }

  Widget showPhoto2() {
    if (_image2 != null && index == 2) {
      return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.file(
            _image2,
            width: 110,
            height: 110,
          ),
        ),
      );
    } else {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    // var cameraPosition = CameraPosition(
    //   target: _lastMapPosition,
    //   zoom: 16,
    // );
    var divw = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("SOS MAP"), actions: <Widget>[]),
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
          // Expanded(
          //     child: ListView(
          //   children: <Widget>[
          //     Container(
          //       // margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
          //       child: Form(
          //         key: formKey,
          //         child: Column(
          //           children: <Widget>[
          //             Row(

          //               children: <Widget>[
          //                 buttonupdatePhoto(),
          //                 Container(
          //                   width: 330.0,
          //                   height: 150,
          //                   color: Colors.blue,
          //                   child: Row(
          //                     children: <Widget>[
          //                       Expanded(
          //                         child: ListView(
          //                           scrollDirection: Axis.horizontal,
          //                           children: <Widget>[
          //                             showPhoto1(), showPhoto2(),showPhoto1(), showPhoto2()
          //                           ],
          //                         ),
          //                       )
          //                       // Text('Photo')
          //                     ],
          //                   ),
          //                   // child: Row(
          //                   //   children: <Widget>[showPhoto1(), showPhoto2()],
          //                   // ),
          //                 )
          //               ],
          //             ),
          //             Container(
          //               margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
          //               child: Column(
          //                 children: <Widget>[
          //                   SizedBox(
          //                     height: 15.0,
          //                   ),
          //                   dropdoweBox(),
          //                   SizedBox(
          //                     height: 15.0,
          //                   ),
          //                   detailText(),
          //                   SizedBox(height: 30),
          //                   addMapTodatabase(),
          //                 ],
          //               ),
          //             )
          //           ],
          //         ),
          //       ),
          //     )
          //   ],
          // ))
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
                    child: Form(
                      key: formKey,
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
                                        showPhoto1(),
                                        showPhoto2()
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
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 15.0,
                        ),
                        dropdoweBox(),
                        SizedBox(
                          height: 15.0,
                        ),
                        detailText(),
                        SizedBox(height: 30),
                        addMapTodatabase(),
                      ],
                    ),
                  ),
                ],
              )

              // Container(
              //   // margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
              //   child: Form(
              //     key: formKey,
              //     child: Column(
              //       children: <Widget>[
              //         Row(

              //           children: <Widget>[
              //             buttonupdatePhoto(),
              //             Container(
              //               width: 330.0,
              //               height: 150,
              //               color: Colors.blue,
              //               child: Row(
              //                 children: <Widget>[
              //                   Expanded(
              //                     child: ListView(
              //                       scrollDirection: Axis.horizontal,
              //                       children: <Widget>[
              //                         showPhoto1(), showPhoto2(),showPhoto1(), showPhoto2()
              //                       ],
              //                     ),
              //                   )
              //                   // Text('Photo')
              //                 ],
              //               ),
              //               // child: Row(
              //               //   children: <Widget>[showPhoto1(), showPhoto2()],
              //               // ),
              //             )
              //           ],
              //         ),
              //         Container(
              //           margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
              //           child: Column(
              //             children: <Widget>[
              //               SizedBox(
              //                 height: 15.0,
              //               ),
              //               dropdoweBox(),
              //               SizedBox(
              //                 height: 15.0,
              //               ),
              //               detailText(),
              //               SizedBox(height: 30),
              //               addMapTodatabase(),
              //             ],
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // )
            ],
          ))
        ],
      ),
    );
  }
}

setPosition(String p) {
  return print("กดเอง $p");
}
