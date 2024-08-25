import 'dart:async';

import 'package:albrandz_task/Assistant/assistantMethods.dart';
import 'package:albrandz_task/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static final CameraPosition _googlePlex = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962), zoom: 14.4746);

  Position? currentPosition;
  var geolocator = Geolocator();
// get users current location
  void locatePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    } else {
      throw Exception('Error');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latlangPosition = LatLng(position.latitude, position.longitude);

    //move camera according to current location
    CameraPosition cameraPosition =
        CameraPosition(target: latlangPosition, zoom: 14);
    _mapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

//to get the coordinates of my address take it from geocoding documentation
    String address = await AssistantMethods.searchCoordinateAddress(position);
    print("Current address: $address");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _googlePlex,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          mapType: MapType.normal,
          onMapCreated: (controller) {
            _controllerGoogleMap.complete(controller);
            _mapController = controller;

            locatePosition();
          },
        ),
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                  color: wColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18)),
                  boxShadow: [
                    BoxShadow(
                      color: bColor,
                      blurRadius: 16,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    )
                  ]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                child: Column(
                  children: [],
                ),
              ),
            ))
      ],
    ));
  }
}
