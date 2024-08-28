import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geocoding/geocoding.dart';

class Map4 extends StatefulWidget {
  @override
  _Map4State createState() => _Map4State();
}

class _Map4State extends State<Map4> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropController = TextEditingController();

  LatLng? _selectedLocation;
  LatLng? _pickupLocation;
  LatLng? _dropLocation;

  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  String? _distance;
  String? _duration;
  bool _isSelectingPickup = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    if (await Geolocator.isLocationServiceEnabled()) {
      final position = await Geolocator.getCurrentPosition();
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          14,
        ),
      );
    } else {
      Geolocator.openLocationSettings();
    }
  }

  Future<String> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      Placemark place = placemarks[0];
      return "${place.street}, ${place.locality}, ${place.country}";
    } catch (e) {
      print(e);
      return "Unknown Location";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Pickup and Drop Locations'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(20.5937, 78.9629), // India
              zoom: 10,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onTap: (position) {
              setState(() {
                _selectedLocation = position;
                _markers.add(
                  Marker(
                    markerId: MarkerId('selectedLocation'),
                    position: position,
                    infoWindow: InfoWindow(title: 'Selected Location'),
                  ),
                );
              });
            },
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Column(
              children: [
                TextField(
                  controller: _pickupController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Select Pickup Location',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onTap: () {
                    setState(() {
                      _isSelectingPickup = true;
                      _selectedLocation = null;
                    });
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _dropController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Select Drop Location',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onTap: () {
                    setState(() {
                      _isSelectingPickup = false;
                      _selectedLocation = null;
                    });
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (_selectedLocation != null) {
                      final address =
                          await _getAddressFromLatLng(_selectedLocation!);
                      setState(() {
                        if (_isSelectingPickup) {
                          _pickupLocation = _selectedLocation;
                          _pickupController.text = address;
                          _markers.add(
                            Marker(
                              markerId: MarkerId('pickup'),
                              position: _pickupLocation!,
                              infoWindow: InfoWindow(title: 'Pickup Location'),
                            ),
                          );
                        } else {
                          _dropLocation = _selectedLocation;
                          _dropController.text = address;
                          _markers.add(
                            Marker(
                              markerId: MarkerId('drop'),
                              position: _dropLocation!,
                              infoWindow: InfoWindow(title: 'Drop Location'),
                            ),
                          );
                        }
                        _updatePolyline();
                        _selectedLocation = null;
                      });
                    }
                  },
                  child: Text('Save Location'),
                ),
              ],
            ),
          ),
          if (_distance != null && _duration != null)
            Positioned(
              bottom: 10,
              left: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Distance: $_distance',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Duration: $_duration',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _updatePolyline() async {
    if (_pickupLocation != null && _dropLocation != null) {
      final directions =
          await _getDirections(_pickupLocation!, _dropLocation!);
      if (directions.isNotEmpty) {
        setState(() {
          _polylines.clear();
          _polylines.add(
            Polyline(
              polylineId: PolylineId('route'),
              points: directions['polyline'] ?? [],
              color: Colors.blue,
              width: 5,
            ),
          );
          _distance = directions['distance'];
          _duration = directions['duration'];
        });
        // Adjust camera to fit polyline
        _mapController?.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: directions['bounds']['southwest'],
              northeast: directions['bounds']['northeast'],
            ),
            50, // Padding
          ),
        );
      } else {
        print('No directions found');
      }
    }
  }

  Future<Map<String, dynamic>> _getDirections(
      LatLng pickup, LatLng drop) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${pickup.latitude},${pickup.longitude}&destination=${drop.latitude},${drop.longitude}&key=YOUR_GOOGLE_API_KEY';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("API Response: $data"); // Log the full response for debugging
      
      final routes = data['routes'] as List;
      if (routes.isNotEmpty) {
        final route = routes.first;
        final polylinePoints = route['overview_polyline']['points'];
        final polylineCoordinates = _decodePolyline(polylinePoints);
        final distance = route['legs'][0]['distance']['text'];
        final duration = route['legs'][0]['duration']['text'];
        final southwest = LatLng(route['bounds']['southwest']['lat'], route['bounds']['southwest']['lng']);
        final northeast = LatLng(route['bounds']['northeast']['lat'], route['bounds']['northeast']['lng']);

        return {
          'polyline': polylineCoordinates,
          'distance': distance,
          'duration': duration,
          'bounds': {
            'southwest': southwest,
            'northeast': northeast,
          },
        };
      } else {
        print("No routes found in the response.");
      }
    } else {
      print("Failed to fetch directions: ${response.statusCode}");
    }
    return {};
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polylineCoordinates = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      LatLng position = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      polylineCoordinates.add(position);
    }

    return polylineCoordinates;
  }
}
