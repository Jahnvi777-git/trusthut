import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _selectedLocation;
  GoogleMapController? _mapController;

  Future<LatLng> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return LatLng(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Location")),
      body: FutureBuilder<LatLng>(
        future: _getCurrentLocation(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: snapshot.data!,
              zoom: 14,
            ),
            onTap: (position) {
              setState(() {
                _selectedLocation = position;
              });
            },
            markers:
                _selectedLocation != null
                    ? {
                      Marker(
                        markerId: MarkerId("selected-location"),
                        position: _selectedLocation!,
                      ),
                    }
                    : {},
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedLocation != null) {
            Navigator.pop(context, {
              'latitude': _selectedLocation!.latitude,
              'longitude': _selectedLocation!.longitude,
              'locationName':
                  "Selected Location", // Replace with reverse geocoding if needed
            });
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Please select a location')));
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
