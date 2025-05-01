import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class EditPostScreen extends StatefulWidget {
  final String postId;
  final Map<String, dynamic> post;

  const EditPostScreen({Key? key, required this.postId, required this.post})
    : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late String _locationName;
  late double _latitude;
  late double _longitude;
  late double _rating;
  bool _isLoading = false;

  GoogleMapController? _mapController;
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    // Initialize fields with existing post data
    _title = widget.post['title'];
    _description = widget.post['description'];
    _locationName = widget.post['locationName'];
    _latitude = widget.post['latitude'];
    _longitude = widget.post['longitude'];
    _rating = widget.post['rating'];
    _selectedLocation = LatLng(_latitude, _longitude);
  }

  void _savePost() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        setState(() {
          _isLoading = true;
        });

        // Update the post in Firestore
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .update({
              'title': _title,
              'description': _description,
              'locationName': _locationName,
              'latitude': _latitude,
              'longitude': _longitude,
              'rating': _rating,
            });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Post updated successfully!')));

        Navigator.pop(context); // Go back to the previous screen
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update post: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TrustHut", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.brown, // Set the brown color for the AppBar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit Post",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Title Input
              TextFormField(
                initialValue: _title,
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
                initialValue: _description,
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
                initialValue: _locationName,
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
                child: GoogleMap(
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
                  markers: {
                    Marker(
                      markerId: MarkerId("selected-location"),
                      position: _selectedLocation!,
                    ),
                  },
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

              SizedBox(height: 20),

              // Submit Button
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                    onPressed: _savePost,
                    icon: Icon(Icons.save, color: Colors.black),
                    label: Text("Save Changes"),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
