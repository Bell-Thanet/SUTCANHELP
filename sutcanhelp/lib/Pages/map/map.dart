import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
    getCurrentLocation();
    _goToMe();
  }

  LocationData currentLocation;
  Completer<GoogleMapController> _controller = Completer();

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

  static const LatLng _center = const LatLng(13.7650836, 100.5379664);
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

  Future _goToSuwannabhumiAirport() async {
    final GoogleMapController controller = await _controller.future;
    currentLocation = await getCurrentLocation();
    controller
        .animateCamera(CameraUpdate.newLatLng(LatLng(13.6900043, 100.7479237)));
  }

  Future _zoomOutToBangkok() async {
    final GoogleMapController controller = await _controller.future;
    currentLocation = await getCurrentLocation();
    controller.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(13.6846021, 100.5883304), 10));
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
      print(LatLng(currentLocation.latitude, currentLocation.longitude));
    });
  }

  Widget bbb() {
    return FloatingActionButton(
        // onPressed: _onAddMarkerButtonPressed,
        onPressed: () {
          setState(() {
            print(po);
          }); 
          
        },
        materialTapTargetSize: MaterialTapTargetSize.padded,
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add_location,
          size: 36.0,
        ));
  }

//bugนะ*************************//** */
  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  @override
  Widget build(BuildContext context) {
    var cameraPosition = CameraPosition(
      target: _lastMapPosition,
      zoom: 16,
    );
    return Scaffold(
      appBar: AppBar(title: Text("My Map"), actions: <Widget>[
        IconButton(
            icon: Icon(Icons.airplanemode_active),
            onPressed: _goToSuwannabhumiAirport),
        IconButton(
          icon: Icon(Icons.home),
          onPressed: _zoomOutToBangkok,
        ),
      ]),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            // onCameraMove: _onCameraMove,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: cameraPosition,
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
                setPosition(position);
              });
              // if(_markers.length < 1){
              //   print("no marker");
              // }
              // print(_markers.first.position);
            },
          ),
          bbb(),
          //  aaa(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToMe,
        label: Text('My location'),
        icon: Icon(Icons.near_me),
        heroTag: null,
      ),
    );
  }
}

void setPosition(LatLng p){
  print(p);
}
