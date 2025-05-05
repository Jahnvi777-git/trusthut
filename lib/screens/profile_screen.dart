import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart'; // Import the Login Screen
import 'post_detail_screen.dart';
import 'edit_post_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to log out: $e')));
    }
  }

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

  void _editPost(String postId, Map<String, dynamic> postData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPostScreen(postId: postId, post: postData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color(0xFFEAF6F6), // Peach for AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Details
            Text(
              "User Details",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2A3A4A)), // Dark blue text
            ),
            SizedBox(height: 8),
            Text(
              "Name: ${_currentUser?.displayName ?? 'Anonymous'}",
              style: TextStyle(fontSize: 16, color: Color(0xFF2A3A4A)), // Dark blue text
            ),
            Text(
              "Email: ${_currentUser?.email ?? 'Not available'}",
              style: TextStyle(fontSize: 16, color: Color(0xFF2A3A4A)), // Dark blue text
            ),
            SizedBox(height: 16),

            // Logout Button
            ElevatedButton.icon(
              onPressed: _logout,
              icon: Icon(Icons.logout),
              label: Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4A90A4), // Teal button color
                foregroundColor: Colors.white, // White text
              ),
            ),
            SizedBox(height: 16),

            // User's Posts
            Text(
              "Your Posts",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2A3A4A)), // Dark blue text
            ),
            SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where('authorId', isEqualTo: _currentUser?.uid)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "An error occurred. Please try again later.",
                        style: TextStyle(fontSize: 16, color: Color(0xFF2A3A4A)), // Dark blue text
                      ),
                    );
                  }

                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    final posts = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index].data() as Map<String, dynamic>;
                        final postId = posts[index].id;

                        return Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          color: Color(0xFF4A90A4), // Teal background for each post
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
                                color: Colors.white, // White text
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
                                    color: Colors.white, // White text
                                  ),
                                ),
                                Text(
                                  "Location: ${post['locationName']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white, // White text
                                  ),
                                ),
                                Text(
                                  "Description: ${post['description']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white, // White text
                                  ),
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.white, // White icon
                              ),
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _editPost(postId, post);
                                } else if (value == 'delete') {
                                  _deletePost(postId);
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostDetailScreen(post: post, postId: postId),
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
                      style: TextStyle(fontSize: 16, color: Color(0xFF2A3A4A)), // Dark blue text
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
