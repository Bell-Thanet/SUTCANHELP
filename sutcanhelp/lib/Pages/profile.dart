import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sutcanhelp/Pages/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:path/path.dart';
import 'package:image_cropper/image_cropper.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File _image;

  String emailLogin = '...';
  String name = '...';
  String uids = '..';
  String pullURL1 = '';
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  @override
  void initState() {
    findDisplayName();
    getdata();
    super.initState();
  }

  Widget showLogoActor() {
    if (_image != null) {
      return Image.file(_image, fit: BoxFit.fill);
    } else if (pullURL1 != null) {
      return pullURL1.isNotEmpty
          ? Container(
              width: 200.0,
              height: 200.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage('$pullURL1'),
                    fit: BoxFit.fill,
                  )),
            )
          : Container();
    } else {
      return Container(
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('images/logoActor.jpg'),
              fit: BoxFit.fill,
            )),
      );
    }
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

  void getdata() async {
    DatabaseReference databaseReference =
        firebaseDatabase.reference().child('Users');
    await databaseReference.once().then((DataSnapshot dataSnapshot) {
      // print('Data ==> ${datasnapshot.value}');
      Map<dynamic, dynamic> values = dataSnapshot.value;
      values.forEach((key, values) {
        if (key == uids) {
          print(values['Email']);
          setState(() {
            name = values['Name'];
            pullURL1 = values['URL'];
          });
          print('Start Pull URL $pullURL1');
          print(values['Name']);
        }

        // print(values['Name']);
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

  Widget logoA() {
    return CircleAvatar(
      radius: 70.0,
      backgroundColor: Colors.blue[900],
      child: ClipOval(
        child: SizedBox(width: 120.0, height: 120.0, child: showLogoActor()
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

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    print(image.lengthSync());
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        compressQuality: 30,
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
    DatabaseReference firebaseAuth = FirebaseDatabase.instance.reference();
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var userid = user.uid.toString();
    await firebaseAuth.child("Users").child(userid).update({
      'URL': url,
    });
    setState(() {
      pullURL1 = url;
    });
    print('Update URL image To $uids and Sucess');
  }

  Widget buttonupdatePhoto() {
    return IconButton(
      icon: Icon(Icons.camera),
      onPressed: () {
        getImage();
      },
      iconSize: 30.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: 'back',
          onPressed: () {
            MaterialPageRoute materialPageRoute =
                MaterialPageRoute(builder: (BuildContext context) => Home());
            Navigator.of(context).pushAndRemoveUntil(
                materialPageRoute, (Route<dynamic> route) => false);
          },
        ),
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                logoA(),
                Padding(
                  padding: const EdgeInsets.only(top: 90.0),
                  child: buttonupdatePhoto(),
                )
              ],
            ),
            SizedBox(height: 20.0),
            showEmailLogin(),
            showNameLogin(),
            RaisedButton(onPressed: () {
              uploadPhoto(context);
            }),
          ],
        )),
      ),
    );
  }
}

//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.lightBlueAccent,
//       appBar: AppBar(
//           // title: Text('ssss'),
//           ),
//       body: ListView(

//         children: <Widget>[
//           Column(
//             children: <Widget>[
//               showLogoActor(),
//               showNameLogin(),
//               showEmailLogin(),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
