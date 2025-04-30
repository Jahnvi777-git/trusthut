import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PostDetailScreen extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostDetailScreen({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LatLng postLocation = LatLng(post['latitude'], post['longitude']);

    return Scaffold(
      appBar: AppBar(title: Text(post['title']), centerTitle: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Google Map Section
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: postLocation,
                zoom: 14,
              ),
              markers: {
                Marker(
                  markerId: MarkerId("post-location"),
                  position: postLocation,
                  infoWindow: InfoWindow(
                    title: post['title'],
                    snippet: post['locationName'],
                  ),
                ),
              },
            ),
          ),
          // Post Details Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post['title'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  "Rating: ${post['rating']} ⭐",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  "Location: ${post['locationName']}",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  "Author: ${post['authorName']}",
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 16),
                Divider(),
                SizedBox(height: 16),
                Text(
                  "Description:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(post['description'], style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
