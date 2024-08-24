import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng? _pickupLocation;
  LatLng? _dropLocation;
  Marker? _pickupMarker;
  Marker? _dropMarker;

  @override
  void initState() {
    super.initState();
    _setPickupLocation();
  }

  Future<void> _setPickupLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _pickupLocation = LatLng(position.latitude, position.longitude);
      _pickupMarker = Marker(
        markerId: MarkerId('pickup'),
        position: _pickupLocation!,
        infoWindow: InfoWindow(title: 'Pickup Location'),
      );
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_pickupLocation!, 14.0),
    );
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _dropLocation = position;
      _dropMarker = Marker(
        markerId: MarkerId('drop'),
        position: _dropLocation!,
        infoWindow: InfoWindow(title: 'Drop Location'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pickup and Drop Locations'),
      ),
      body: _pickupLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _pickupLocation!,
                zoom: 14.0,
              ),
              markers: {
                if (_pickupMarker != null) _pickupMarker!,
                if (_dropMarker != null) _dropMarker!,
              },
              onTap: _onMapTapped,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
    );
  }
}
