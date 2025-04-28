import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'post_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  void _deletePost(String postId) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Post deleted successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete post: $e')));
    }
  }

  void _editPost(String postId, Map<String, dynamic> postData) async {
    // Navigate to an edit screen (not implemented here)
    // Pass the postId and postData to the edit screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Details
            Text(
              "User Details",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Name: ${_currentUser?.displayName ?? 'Anonymous'}"),
            Text("Email: ${_currentUser?.email ?? 'Not available'}"),
            SizedBox(height: 16),

            // User's Posts
            Text(
              "Your Posts",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('posts')
                        .where('authorId', isEqualTo: _currentUser?.uid)
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    print("Error: ${snapshot.error}"); // Debug log for errors
                    return Center(
                      child: Text(
                        "An error occurred. Please try again later.",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  }

                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    final posts = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post =
                            posts[index].data() as Map<String, dynamic>;
                        final postId = posts[index].id;

                        return Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          color: Color(
                            0xFF331C08,
                          ), // Dark background for each post
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Text(
                              post['title'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFD3AC), // Light text
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                Text(
                                  "Rating: ${post['rating']} ⭐",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFFFD3AC), // Light text
                                  ),
                                ),
                                Text(
                                  "Location: ${post['location']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFFFD3AC), // Light text
                                  ),
                                ),
                                Text(
                                  "Description: ${post['description']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFFFD3AC), // Light text
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => PostDetailScreen(post: post),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }

                  return Center(
                    child: Text(
                      "You haven't posted anything yet.",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
