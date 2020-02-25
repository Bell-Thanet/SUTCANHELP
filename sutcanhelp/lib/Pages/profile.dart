import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sutcanhelp/Pages/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:path/path.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'dart:ui' as ui;

import 'package:sutcanhelp/widget/loading.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File _image;

  String emailLogin = '...';
  String name = '...';
  String uids = '';
  String pullURL = '';
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  @override
  void initState() {
    super.initState();
    findDisplayName();
    getdata();
  }

  Widget showEmailLogin() {
    return Text(
      '$emailLogin',
      style: TextStyle(fontSize: 30.0, color: Colors.white),
    );
  }

  Widget showNameLogin() {
    return Text(
      '$name',
      style: TextStyle(fontSize: 30.0, color: Colors.white),
    );
  }

  Widget showLogoActor() {
    if (_image != null) {
      return Image.file(_image, fit: BoxFit.fill);
    } else if (pullURL != 'null') {
      return pullURL.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: "$pullURL",
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            )
          //  CircleAvatar(
          //           radius: 100,
          //           backgroundImage: NetworkImage(pullURL),
          //         )

          // Container(
          //     width: 200.0,
          //     height: 200.0,
          //     decoration: BoxDecoration(
          //         shape: BoxShape.circle,
          //         image: DecorationImage(
          //           // image: NetworkImage('$pullURL'),
          //           image: AssetImage('images/logoActor.jpg'),
          //           fit: BoxFit.fill,
          //         )),
          //   )
          : Container();
    } else {
      return Container(
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('images/logoActor.png'),
              fit: BoxFit.fill,
            )),
      );
    }
  }

// CircleAvatar(
//                     radius: _width < _height ? _width / 4 : _height / 4,
//                     backgroundImage: NetworkImage(imgUrl),
//                   ),
  Widget logoCircle() {
    return CircleAvatar(
      radius: 100.0,
      backgroundColor: Colors.blue[500],
      child: ClipOval(
        child: SizedBox(width: 180.0, height: 180.0, child: showLogoActor()
            //     ? Image.file(_image, fit: BoxFit.fill)
            //     // ? Image.network(
            //     //     pullURL1,
            //     //     fit: BoxFit.fill,
            //     //   )
            //     : showLogoActor()
            // // : Image.network(
            // //     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQJR6BqqLi6y004j182y-DQqexGNssQn5AHlZ7DUBXpYQe3H7P&s',
            // //     fit: BoxFit.fill,
            // //   ),
            ),
      ),
    );
  }

  Widget buttonupdatePhoto() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50.0),
      child: Container(
        color: Colors.lightBlueAccent,
        child: IconButton(
          icon: Icon(Icons.camera),
          onPressed: () {
            setImage();
          },
          iconSize: 50.0,
        ),
      ),
    );
  }

  bool loading = false;

  Future<void> getdata() async {
    loading = true;
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    setState(() {
      String uids = firebaseUser.uid;
      final DocumentReference documentReference =
          Firestore.instance.document('Users/$uids');
      documentReference.get().then((datasnapshot) {
        if (datasnapshot.exists) {
          setState(() {
            name = datasnapshot.data['Name'];
            pullURL = datasnapshot.data['URL'];
            print('Name = $name /t URL = $pullURL');
            loading = false;
          });
        }
      });
    });
  }

  Future<void> findDisplayName() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    setState(() {
      emailLogin = firebaseUser.email;
      uids = firebaseUser.uid;
    });
    return emailLogin;
  }

  Future setImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    print(image.lengthSync());
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        compressQuality: 40,
        maxHeight: 200,
        maxWidth: 200,
        cropStyle: CropStyle.circle,
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
      _image = croppedFile;
      print("Impge Patn $_image");
    });
  }

  Future uploadPhoto(BuildContext context) async {
    // String filName = basename(_image.path);
    print(_image.lengthSync());

    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('ProfileUsers').child(uids);

    StorageUploadTask storageUploadTask = firebaseStorageRef.putFile(_image);
    // StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    var downUrl =
        await (await storageUploadTask.onComplete).ref.getDownloadURL();
    var url = downUrl.toString();
    print("Download URL $url");
    setURLImage(url);
    setState(() {
      print("Profile Picture update");
      // pullURL = url;
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Profile Picture Update"),
      ));
    });
  }

  Future<void> setURLImage(url) async {
    // final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uids = user.uid.toString();
    final DocumentReference documentReference =
        Firestore.instance.document('Users/$uids');
    Map<String, String> data = <String, String>{"URL": url};
    documentReference.updateData(data).whenComplete(() {
      setState(() {
        pullURL = url;
        print('Update URL image To $uids and Sucess');
      });
    }).catchError((e) => print(e));
  }

  Widget editdataButton(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      // shadowColor: Colors.black54,
      // elevation: 5.0,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        height: 56.0,
        onPressed: () {
          uploadPhoto(context);
        },
        child: Text('แก้ไขข้อมูล',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.bold)),
      ),
      color: Colors.lightBlueAccent,
    );
  }

  @override
  Widget build(BuildContext context) {
    var divheight = MediaQuery.of(context).size.height;
    var divwidth = MediaQuery.of(context).size.width;
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.lightBlueAccent,
            appBar: AppBar(
              title: Center(
                child: Text(
                  'Profile',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              // centerTitle: true,
              // leading: IconButton(
              //   icon: Icon(Icons.arrow_back),
              //   tooltip: 'back',
              //   onPressed: () {
              //     // MaterialPageRoute materialPageRoute =
              //     //     MaterialPageRoute(builder: (BuildContext context) => Home());
              //     // Navigator.of(context).pushAndRemoveUntil(
              //     //     materialPageRoute, (Route<dynamic> route) => false);
              //   },
              // ),

              // actions: <Widget>[
              //   IconButton(
              //     icon: Icon(Icons.ac_unit),
              //     tooltip: 'back',
              //     onPressed: () {
              //       MaterialPageRoute materialPageRoute =
              //           MaterialPageRoute(builder: (BuildContext context) => Home());
              //       Navigator.of(context).pushAndRemoveUntil(
              //           materialPageRoute, (Route<dynamic> route) => false);
              //     },
              //   ),
              // ],
            ),
            body: Builder(
              builder: (context) => Container(
                  child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Container(
                      alignment: Alignment.center,
                      child: Stack(
                        children: <Widget>[
                          logoCircle(),
                          Padding(
                            padding: const EdgeInsets.only(left: 130, top: 130),
                            child: buttonupdatePhoto(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(height: 30, color: Colors.black87),
                  Stack(
                    children: <Widget>[
                      Center(
                        child: Container(
                          height: 150,
                          width: divwidth / 1.3,
                          decoration: BoxDecoration(
                            color: Colors.blue[300],
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: Colors.blue,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              showNameLogin(),
                              SizedBox(height: 15),
                              showEmailLogin(),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          padding:
                              EdgeInsets.only(top: 120, left: 40, right: 40),
                          child: editdataButton(context))
                    ],
                  ),
                  // Container(
                  //   child: Stack(
                  //     children: <Widget>[
                  //       // showEmailLogin(),

                  //       Padding(
                  //         padding: EdgeInsets.only(top: 140),
                  //         child: Container(child: editdataButton(context)),
                  //       ),
                  //       // RaisedButton(onPressed: () {
                  //       //   uploadPhoto(context);
                  //       // }),
                  //     ],
                  //   ),
                  // ),

                  // Stack(
                  //   children: <Widget>[
                  //     showEmailLogin(),
                  //     showNameLogin(),
                  //     RaisedButton(onPressed: () {
                  //       uploadPhoto(context);
                  //     }),
                  //   ],
                  // ),
                ],
              )),
            ),
            // bottomNavigationBar: BottomNavigationProfile()
          );
  }
}
