import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class EditPostScreen extends StatefulWidget {
  final String postId;
  final Map<String, dynamic> postData;

  const EditPostScreen({Key? key, required this.postId, required this.postData})
    : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late String _location;
  late double _rating;

  @override
  void initState() {
    super.initState();
    _title = widget.postData['title'];
    _description = widget.postData['description'];
    _location = widget.postData['location'];
    _rating = widget.postData['rating'];
  }

  void _updatePost() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .update({
              'title': _title,
              'description': _description,
              'location': _location,
              'rating': _rating,
            });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Post updated successfully!')));

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update post: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Post")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: "Title"),
                onSaved: (value) => _title = value!.trim(),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? "Please enter a title"
                            : null,
              ),
              SizedBox(height: 16),

              // Description Field
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: "Description"),
                onSaved: (value) => _description = value!.trim(),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? "Please enter a description"
                            : null,
                maxLines: 3,
              ),
              SizedBox(height: 16),

              // Location Field
              TextFormField(
                initialValue: _location,
                decoration: InputDecoration(labelText: "Location"),
                onSaved: (value) => _location = value!.trim(),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? "Please enter a location"
                            : null,
              ),
              SizedBox(height: 16),

              // Rating Bar
              Text(
                "Rating:",
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

              // Update Button
              ElevatedButton(
                onPressed: _updatePost,
                child: Text("Update Post"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
