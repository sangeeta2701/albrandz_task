import 'package:albrandz_task/mapConfig.dart';
import 'package:albrandz_task/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class Map3 extends StatefulWidget {
  const Map3({super.key});

  @override
  _Map3State createState() => _Map3State();
}

class _Map3State extends State<Map3> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropController = TextEditingController();

  LatLng? _pickupLocation;
  LatLng? _dropLocation;

  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  String? _distance;
  String? _duration;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Locations',style: blackMainHeading,),
      ),
      body: Column(
        children: [
          TextField(
            controller: _pickupController,
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'Select Pickup Location',
               hintStyle: greyTextStyle
            ),
            onTap: () async {
              final LatLng? location = await _selectLocation();
              if (location != null) {
                setState(() {
                  _pickupLocation = location;
                  _pickupController.text = 'Pickup: ${location.latitude}, ${location.longitude}';
                  _markers.add(
                    Marker(
                      markerId: MarkerId('pickup'),
                      position: location,
                      infoWindow: InfoWindow(title: 'Pickup Location'),
                    ),
                  );
                  _updatePolyline();
                });
              }
            },
          ),
          TextField(
            controller: _dropController,
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'Select Drop Location',
              hintStyle: greyTextStyle
            ),
            onTap: () async {
              final LatLng? location = await _selectLocation();
              if (location != null) {
                setState(() {
                  _dropLocation = location;
                  _dropController.text = 'Drop: ${location.latitude}, ${location.longitude}';
                  _markers.add(
                    Marker(
                      markerId: MarkerId('drop'),
                      position: location,
                      infoWindow: InfoWindow(title: 'Drop Location'),
                    ),
                  );
                  _updatePolyline();
                });
              }
            },
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(20.5937, 78.9629), // India
                zoom: 10,
              ),
              markers: _markers,
              polylines: _polylines,
            ),
          ),
          if (_distance != null && _duration != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Distance: $_distance', style: blackContent,),
                  Text('Duration: $_duration',style: blackContent,),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<LatLng?> _selectLocation() async {
    LatLng? selectedLocation;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerScreen(
          onLocationSelected: (location) {
            selectedLocation = location;
          },
        ),
      ),
    );
    return selectedLocation;
  }

  Future<void> _updatePolyline() async {
    if (_pickupLocation != null && _dropLocation != null) {
      final directions = await _getDirections(_pickupLocation!, _dropLocation!);
      setState(() {
        _polylines.add(
          Polyline(
            polylineId: PolylineId('route'),
            points: directions['polyline'],
            color: Colors.blue,
            width: 5,
          ),
        );
        _distance = directions['distance'];
        _duration = directions['duration'];
      });
    }
  }

  Future<Map<String, dynamic>> _getDirections(LatLng pickup, LatLng drop) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${pickup.latitude},${pickup.longitude}&destination=${drop.latitude},${drop.longitude}&key=$mapKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final routes = data['routes'] as List;
      if (routes.isNotEmpty) {
        final route = routes.first;
        final polylinePoints = route['overview_polyline']['points'];
        final polylineCoordinates = _decodePolyline(polylinePoints);
        final distance = route['legs'][0]['distance']['text'];
        final duration = route['legs'][0]['duration']['text'];

        return {
          'polyline': polylineCoordinates,
          'distance': distance,
          'duration': duration,
        };
      }
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

class LocationPickerScreen extends StatefulWidget {
  final Function(LatLng) onLocationSelected;

  LocationPickerScreen({required this.onLocationSelected});

  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _controller;
  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
        actions: [
          if (_selectedLocation != null)
            TextButton(
              onPressed: () {
                widget.onLocationSelected(_selectedLocation!);
                Navigator.pop(context);
              },
              child: Text(
                'Select',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          _controller = controller;
          _setInitialLocation();
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(20.5937, 78.9629), // India
          zoom: 5,
        ),
        onTap: (position) {
          setState(() {
            _selectedLocation = position;
          });
        },
        markers: _selectedLocation != null
            ? {
                Marker(
                  markerId: MarkerId('selectedLocation'),
                  position: _selectedLocation!,
                ),
              }
            : {},
      ),
    );
  }

  Future<void> _setInitialLocation() async {
    if (await Geolocator.isLocationServiceEnabled()) {
      final position = await Geolocator.getCurrentPosition();
      _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          14,
        ),
      );
    }
  }
}
