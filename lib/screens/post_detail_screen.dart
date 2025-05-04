import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostDetailScreen extends StatefulWidget {
  final Map<String, dynamic> post;
  final String postId;

  const PostDetailScreen({Key? key, required this.post, required this.postId})
    : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late Map<String, dynamic> post;

  @override
  void initState() {
    super.initState();
    post = widget.post; // Initialize with the passed post data
  }

  Future<void> toggleLike(String postId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // Ensure the user is logged in

    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);

    final postSnapshot = await postRef.get();
    final postData = postSnapshot.data() as Map<String, dynamic>;

    if (postData['likedBy'] != null &&
        (postData['likedBy'] as List).contains(user.uid)) {
      // Unlike the post
      await postRef.update({
        'likes': FieldValue.increment(-1),
        'likedBy': FieldValue.arrayRemove([user.uid]),
      });
    } else {
      // Like the post
      await postRef.update({
        'likes': FieldValue.increment(1),
        'likedBy': FieldValue.arrayUnion([user.uid]),
      });
    }

    // Fetch the updated post data and update the UI
    final updatedPostSnapshot = await postRef.get();
    setState(() {
      post = updatedPostSnapshot.data() as Map<String, dynamic>;
    });
  }

  @override
  Widget build(BuildContext context) {
    final LatLng postLocation = LatLng(post['latitude'], post['longitude']);

    return Scaffold(
      appBar: AppBar(
        title: Text("TrustHut", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Rating: ${post['rating']} ⭐",
                      style: TextStyle(fontSize: 18),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            (post['likedBy'] != null &&
                                    (post['likedBy'] as List).contains(
                                      FirebaseAuth.instance.currentUser?.uid,
                                    ))
                                ? Icons.thumb_up
                                : Icons.thumb_up_outlined,
                            color: Colors.amber,
                          ),
                          onPressed: () async {
                            await toggleLike(widget.postId);
                          },
                        ),
                        Text(
                          "${post['likes'] ?? 0}", // Display the number of likes
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
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
