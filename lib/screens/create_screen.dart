import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Import RatingBar package

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _location = '';
  String _authorName = '';
  bool _isAnonymous = false;
  double _rating = 0.0; // Variable to store the rating

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      print("Form is valid. Proceeding with submission...");
      _formKey.currentState!.save();

      try {
        // Prepare post data
        final postData = {
          'title': _title,
          'description': _description,
          'location': _location,
          'rating': _rating,
          'isAnonymous': _isAnonymous,
          'authorName': _isAnonymous ? 'Anonymous' : _authorName,
          'timestamp': Timestamp.now(),
        };

        // Upload post data to Firestore
        await FirebaseFirestore.instance.collection('posts').add(postData);

        // Print confirmation
        print("Post successfully stored in Firestore: $postData");

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post created successfully!')),
        );

        // Reset the form and state
        _formKey.currentState!.reset();
        setState(() {
          _rating = 0.0;
          _isAnonymous = false;
        });
      } catch (e) {
        print("Error during submission: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create post. Please try again.')),
        );
      }
    } else {
      print("Form is invalid. Please check the fields.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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

            TextFormField(
              decoration: InputDecoration(labelText: 'Title'),
              onSaved: (value) => _title = value!.trim(),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter a title' : null,
            ),

            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              onSaved: (value) => _description = value!.trim(),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a description'
                  : null,
              maxLines: 3,
            ),

            TextFormField(
              decoration: InputDecoration(labelText: 'Location'),
              onSaved: (value) => _location = value!.trim(),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter a location' : null,
            ),

            if (!_isAnonymous)
              TextFormField(
                decoration: InputDecoration(labelText: 'Your Name'),
                onSaved: (value) => _authorName = value!.trim(),
                validator: (value) => !_isAnonymous && (value == null || value.isEmpty)
                    ? 'Please enter your name'
                    : null,
              ),

            Row(
              children: [
                Checkbox(
                  value: _isAnonymous,
                  onChanged: (val) {
                    setState(() {
                      _isAnonymous = val!;
                    });
                  },
                ),
                Text("Post Anonymously"),
              ],
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
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),

            SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _submitForm,
              icon: Icon(Icons.send, color: Colors.black), // Ensure icon is black
              label: Text("Submit Post"),
            ),
          ],
        ),
      ),
    );
  }
}
