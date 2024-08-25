
import 'package:albrandz_task/mapConfig.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Map2 extends StatefulWidget {
  @override

  _Map2State createState() => _Map2State();
}

class _Map2State extends State<Map2> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  LatLng? _pickupLocation;
  LatLng? _dropOffLocation;
  TextEditingController _pickupController = TextEditingController();
  TextEditingController _dropOffController = TextEditingController();

  bool isSelectingDropOff = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _pickupLocation =
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
      _getAddressFromLatLng(_pickupLocation!, true);
    });
  }

  Future<void> _getAddressFromLatLng(LatLng latLng, bool isPickup) async {
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$mapKey';

    final response = await http.get(Uri.parse(url));
    final jsonResponse = jsonDecode(response.body);

    if (jsonResponse['results'].isNotEmpty) {
      final formattedAddress = jsonResponse['results'][0]['formatted_address'];
      setState(() {
        if (isPickup) {
          _pickupController.text = formattedAddress;
        } else {
          _dropOffController.text = formattedAddress;
        }
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _selectLocation(LatLng latLng) {
    setState(() {
      if (isSelectingDropOff) {
        _dropOffLocation = latLng;
        _getAddressFromLatLng(latLng, false);
        isSelectingDropOff = false;
        Navigator.pop(context); // Return to the previous screen
      } else {
        _pickupLocation = latLng;
        _getAddressFromLatLng(latLng, true);
      }
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pickup & Drop Location'),
      ),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _pickupLocation ?? LatLng(0, 0),
                      zoom: 14.0,
                    ),
                    myLocationEnabled: true,
                    mapType: MapType.normal,
                    myLocationButtonEnabled: true,
                    onTap: (latLng) {
                      _selectLocation(latLng);
                    },
                    markers: {
                      if (_pickupLocation != null)
                        Marker(
                          markerId: MarkerId('pickup'),
                          position: _pickupLocation!,
                          infoWindow: InfoWindow(title: 'Pickup Location'),
                        ),
                      if (_dropOffLocation != null)
                        Marker(
                          markerId: MarkerId('dropoff'),
                          position: _dropOffLocation!,
                          infoWindow: InfoWindow(title: 'Drop-off Location'),
                        ),
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _pickupController,
                        readOnly: true,
                        decoration: InputDecoration(
                            hintText: _pickupLocation.toString()),
                      ),
                      GestureDetector(
                        // onTap: _onDropOffFieldTap,
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _dropOffController,
                         
                            decoration: InputDecoration(
                              labelText: 'Drop-off Location',
                            ),
                            onTap: () {
                              setState(() {
                                _dropOffController.text =
                                    _dropOffLocation.toString();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
