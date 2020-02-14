import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

// class Sos extends StatelessWidget {

//   // 13.7248936,100.4930264

//   static final CameraPosition cameraPosition = CameraPosition(

//       target: LatLng(13.7248936, -100.4930264),

//       zoom: 19.151926040649414);

//   @override
//   Widget build(BuildContext context) {
//     return GoogleMap(
//       initialCameraPosition: cameraPosition,
//     );
//   }
// }

class Sos extends StatefulWidget {
  @override
  _SosState createState() => _SosState();

}
class _SosState extends State<Sos> {

  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(45.521563, -122.677433);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;
  static final CameraPosition _position1 = CameraPosition(
    bearing: 192.833
    // target:
  );

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
            title: 'This is a Title',
            snippet: 'This is a snippet',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  // Widget button(Function function, IconData icon) {
  //   return FloatingActionButton(
  //     onPressed: function,
  //     materialTapTargetSize: MaterialTapTargetSize.padded,
  //     backgroundColor: Colors.blue,
  //     child: Icon(
  //       icon,
  //       size: 36.0,
  //     ),
  //   );
  // }

  Widget aaa(){
    return FloatingActionButton(
      onPressed: _onMapTypeButtonPressed,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(
        Icons.map,
        size: 36.0,
      )
    );
  }
  Widget bbb(){
    return FloatingActionButton(
      onPressed: _onAddMarkerButtonPressed,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(
        Icons.add_location,
        size: 36.0,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
      appBar: AppBar(
        title: Text("MAP"),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            mapType: _currentMapType,
            markers: _markers,
            onCameraMove: _onCameraMove,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  aaa(),
                  SizedBox(
                    height: 16.0,
                  ),
                  bbb(),
                  // button(_onAddMarkerButtonPressed, Icons.add_location),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }
}

//********************* */
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// void main() => runApp(Sos());

// class Sos extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   List<Marker> allMarkers = [];

//   GoogleMapController _controller;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     allMarkers.add(Marker(
//         markerId: MarkerId('myMarker'),
//         draggable: true,
//         onTap: () {
//           print('Marker Tapped');
//         },
//         position: LatLng(40.7128, -74.0060)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Maps'),
//       ),
//       body: Stack(children: [
//         Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: GoogleMap(
//             initialCameraPosition:
//                 CameraPosition(target: LatLng(40.7128, -74.0060), zoom: 12.0),
//             markers: Set.from(allMarkers),
//             onMapCreated: mapCreated,
        
//           ),
//         ),
//         Align(
//           alignment: Alignment.bottomCenter,
//           child: InkWell(
//             onTap: movetoBoston,
//             child: Container(
//               height: 40.0,
//               width: 40.0,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20.0),
//                   color: Colors.green),
//               child: Icon(Icons.forward, color: Colors.white),
//             ),
//           ),
//         ),
//         Align(
//           alignment: Alignment.bottomRight,
//           child: InkWell(
//             onTap: movetoNewYork,
//             child: Container(
//               height: 40.0,
//               width: 40.0,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20.0), color: Colors.red),
//               child: Icon(Icons.backspace, color: Colors.white),
//             ),
//           ),
//         ),
//         // Align(
//         //   alignment: Alignment.topCenter,
//         //   child: InkWell(
//         //     onTap: null,
//         //     child: Container(
//         //       height: 40.0,
//         //       width: 40.0,
//         //       decoration: BoxDecoration(
//         //           borderRadius: BorderRadius.circular(20.0), color: Colors.red),
//         //       child: Icon(Icons.backspace, color: Colors.white),
//         //     ),
//         //   ),
//         // ),
//       ]),
//     );
//   }



//   void mapCreated(controller) {
//     setState(() {
//       _controller = controller;
//     });
//   }

//   movetoBoston() {
//     _controller.animateCamera(CameraUpdate.newCameraPosition(
//       CameraPosition(
//           target: LatLng(42.3601, -71.0589),
//           zoom: 14.0,
//           bearing: 45.0,
//           tilt: 45.0),
//     ));
//   }

//   movetoNewYork() {
//     _controller.animateCamera(CameraUpdate.newCameraPosition(
//       CameraPosition(target: LatLng(40.7128, -74.0060), zoom: 12.0),
//     ));
//   }
// }
