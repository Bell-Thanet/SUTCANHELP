import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

// class SosPage extends StatefulWidget {
//   @override
//   _SosPageState createState() => _SosPageState();
// }

// class _SosPageState extends State<SosPage> {
//   Completer<GoogleMapController> _controller = Completer();
//   static const LatLng _center = const LatLng(45.521563, -122.677433);
//   final Set<Marker> _markers = {};
//   LatLng _lastMapPosition = _center;
//   MapType _currentMapType = MapType.normal;

//   static final CameraPosition _position1 = CameraPosition(
//       bearing: 192.833,
//       target: LatLng(45.534563, -122.677433),
//       tilt: 59.440,
//       zoom: 11.0);

//   Future<void> _goToPosition1() async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(_position1));
//   }

//   _onMapCreated(GoogleMapController controller) {
//     _controller.complete(controller);
//   }

//   _onCameraMove(CameraPosition position) {
//     _lastMapPosition = position.target;
//   }

//   _onMapTypeButtonPressed() {
//     setState(() {
//       _currentMapType = _currentMapType == MapType.normal
//           ? MapType.satellite
//           : MapType.normal;
//     });
//   }

//   _onAddMarkerButtonPressed() {
//     setState(() {
//       _markers.add(Marker(
//         markerId: MarkerId(_lastMapPosition.toString()),
//         position: _lastMapPosition,
//         infoWindow: InfoWindow(
//           title: 'This is a Title',
//           snippet: 'This is a snoppet',
//         ),
//         icon: BitmapDescriptor.defaultMarker,
//       ));
//     });
//   }

//   Widget button(Function function, IconData icon) {
//     return FloatingActionButton(
//       onPressed: function,
//       materialTapTargetSize: MaterialTapTargetSize.padded,
//       backgroundColor: Colors.blue,
//       child: Icon(
//         icon,
//         size: 36.0,
//       ),
//     );
//   }
//********************************** */
//   GoogleMapController _controller;
//   Position position;
//   Widget _child;

//   Future<void> getPermission() async {
//     PermissionStatus permission = await PermissionHandler()
//         .checkPermissionStatus(PermissionGroup.location);
//     if (permission == PermissionStatus.denied) {
//       await PermissionHandler()
//           .requestPermissions([PermissionGroup.locationAlways]);
//     }
//     var geolocator = Geolocator();
//     GeolocationStatus geolocationStatus =
//         await geolocator.checkGeolocationPermissionStatus();

//     switch (geolocationStatus) {
//     }
//   }

// void showToast(message)(Fluttertoast.showToast())

//******************* */
  // GoogleMapController _controller;

  // Position position;
  // Widget _child;



  // Future<void> getLocation() async {
  //   PermissionStatus permission = await PermissionHandler()
  //       .checkPermissionStatus(PermissionGroup.location);

  //   if (permission == PermissionStatus.denied) {
  //     await PermissionHandler()
  //         .requestPermissions([PermissionGroup.locationAlways]);
  //   }

  //   var geolocator = Geolocator();

  //   GeolocationStatus geolocationStatus =
  //       await geolocator.checkGeolocationPermissionStatus();

  //   switch (geolocationStatus) {
  //     case GeolocationStatus.denied:
  //       showToast('denied');
  //       break;
  //     case GeolocationStatus.disabled:
  //       showToast('disabled');
  //       break;
  //     case GeolocationStatus.restricted:
  //       showToast('restricted');
  //       break;
  //     case GeolocationStatus.unknown:
  //       showToast('unknown');
  //       break;
  //     case GeolocationStatus.granted:
  //       showToast('Access granted');
  //       _getCurrentLocation();
  //   }
  // }

  // void _setStyle(GoogleMapController controller) async {
  //   String value = await DefaultAssetBundle.of(context)
  //       .loadString('assets/map_style.json');
  //   controller.setMapStyle(value);
  // }
  // Set<Marker> _createMarker(){
  //   return <Marker>[
  //     Marker(
  //       markerId: MarkerId('home'),
  //       position: LatLng(position.latitude,position.longitude),
  //       icon: BitmapDescriptor.defaultMarker,
  //       infoWindow: InfoWindow(title: 'Current Location')
  //     )
  //   ].toSet();
  // }

  // void showToast(message){
  //   Fluttertoast.showToast(
  //     msg: message,
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //       timeInSecForIos: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0
  //   );
  // }
  // @override
  // void initState() {
  //   getLocation();
  //   super.initState();
  // }
  // void _getCurrentLocation() async{
  //   Position res = await Geolocator().getCurrentPosition();
  //   setState(() {
  //     position = res;
  //     _child = _mapWidget();
  //   });
  // }


  // Widget _mapWidget(){
  //   return GoogleMap(
  //     mapType: MapType.normal,
  //     markers: _createMarker(),
  //     initialCameraPosition: CameraPosition(
  //       target: LatLng(position.latitude,position.longitude),
  //       zoom: 12.0,
  //     ),
  //     onMapCreated: (GoogleMapController controller){
  //       _controller = controller;
  //       _setStyle(controller);
  //     },
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Google Map',textAlign: TextAlign.center,style: TextStyle(color: CupertinoColors.white),),
  //     ),
  //   body: _child,










//*********** */

      // body: Stack(
      //   children: <Widget>[
      //     GoogleMap(
      //       onMapCreated: _onMapCreated,
      //       initialCameraPosition: CameraPosition(
      //         target: _center,
      //         zoom: 11.0,
      //       ),
      //       mapType: _currentMapType,
      //       markers: _markers,
      //       onCameraMove: _onCameraMove,
      //     ),
      //     Padding(
      //       padding: EdgeInsets.all(16.0),
      //       child: Align(
      //         alignment: Alignment.topRight,
      //         child: Column(
      //           children: <Widget>[
      //             button(_onMapTypeButtonPressed, Icons.map),
      //             SizedBox(
      //               height: 16.0,
      //             ),
      //             button(_onAddMarkerButtonPressed, Icons.add_location),
      //             SizedBox(
      //               height: 16.0,
      //             ),
      //             // button(_goToPosition1, Icons.location_searching),
      //           ],
      //         ),
      //       ),
      //     )
      //   ],
      // )

      //************************* */
//     );
//   }
// }
