import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trusthut/screens/home_screen.dart';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String? _locationName;
  double? _latitude;
  double? _longitude;
  bool _isLoading = false;
  double _rating = 0.0;
  bool _isAnonymous = false; // Track if the post is anonymous

  LatLng? _selectedLocation;
  GoogleMapController? _mapController;

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _selectedLocation = LatLng(position.latitude, position.longitude);
    });
  }

  void _savePost() async {
    if (_formKey.currentState!.validate() &&
        _latitude != null &&
        _longitude != null) {
      _formKey.currentState!.save();

      try {
        setState(() {
          _isLoading = true;
        });

        final user = FirebaseAuth.instance.currentUser;

        final postData = {
          'title': _title,
          'description': _description,
          'locationName': _locationName ?? 'Unknown Location',
          'latitude': _latitude,
          'longitude': _longitude,
          'rating': _rating,
          'authorId': _isAnonymous ? null : user!.uid,
          'authorName':
              _isAnonymous ? 'Anonymous' : user?.displayName ?? 'Anonymous',
          'isAnonymous': _isAnonymous,
          'timestamp': Timestamp.now(),
          'likes': 0, // Initialize likes to 0
          'likedBy': [], // Initialize likedBy as an empty list
        };

        await FirebaseFirestore.instance.collection('posts').add(postData);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Post created successfully!')));

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to create post: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select a location')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create a New Post",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Title Input
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (value) => _title = value!.trim(),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter a title'
                            : null,
              ),

              // Description Input
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value!.trim(),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter a description'
                            : null,
                maxLines: 3,
              ),

              SizedBox(height: 16),

              // Location Name Input
              TextFormField(
                decoration: InputDecoration(labelText: 'Location Name'),
                onChanged: (value) => _locationName = value.trim(),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter a location name'
                            : null,
              ),

              SizedBox(height: 16),

              // Google Map for Location Selection
              Container(
                height: 300,
                child:
                    _selectedLocation == null
                        ? Center(child: CircularProgressIndicator())
                        : GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _selectedLocation!,
                            zoom: 14,
                          ),
                          onMapCreated: (controller) {
                            _mapController = controller;
                          },
                          onTap: (position) {
                            setState(() {
                              _latitude = position.latitude;
                              _longitude = position.longitude;
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
                        ),
              ),

              SizedBox(height: 16),

              // Rating Bar
              Text(
                "Rate this location:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder:
                    (context, _) => Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),

              SizedBox(height: 16),

              // Anonymous Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _isAnonymous,
                    onChanged: (value) {
                      setState(() {
                        _isAnonymous = value!;
                      });
                    },
                  ),
                  Text("Post as Anonymous"),
                ],
              ),

              SizedBox(height: 20),

              // Submit Button
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                    onPressed: _savePost,
                    icon: Icon(Icons.send, color: Colors.black),
                    label: Text("Submit Post"),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
