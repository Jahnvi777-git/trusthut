import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'post_detail_screen.dart'; // Import the PostDetailScreen

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  String _titleQuery = '';
  String _locationQuery = '';
  String _authorQuery = '';
  double? _ratingQuery;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search Bars
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Search by Title
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Search by Title',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _titleQuery = value.trim().toLowerCase();
                    });
                  },
                ),
                SizedBox(height: 8),

                // Search by Location
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Search by Location',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _locationQuery = value.trim().toLowerCase();
                    });
                  },
                ),
                SizedBox(height: 8),

                // Search by Author
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Search by Author',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _authorQuery = value.trim().toLowerCase();
                    });
                  },
                ),
                SizedBox(height: 8),

                // Search by Rating
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Search by Rating (e.g., 4.5)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _ratingQuery = double.tryParse(value);
                    });
                  },
                ),
              ],
            ),
          ),

          // Posts List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('posts').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "No posts found.",
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                final posts = snapshot.data!.docs;

                // Filter posts based on search queries
                final filteredPosts =
                    posts.where((doc) {
                      final post = doc.data() as Map<String, dynamic>;
                      final title = post['title']?.toLowerCase() ?? '';
                      final location =
                          post['locationName']?.toLowerCase() ?? '';
                      final author = post['authorName']?.toLowerCase() ?? '';
                      final rating = post['rating']?.toDouble() ?? 0.0;

                      return (title.contains(_titleQuery)) &&
                          (location.contains(_locationQuery)) &&
                          (author.contains(_authorQuery)) &&
                          (_ratingQuery == null || rating >= _ratingQuery!);
                    }).toList();

                return ListView.builder(
                  itemCount: filteredPosts.length,
                  itemBuilder: (context, index) {
                    final post =
                        filteredPosts[index].data() as Map<String, dynamic>;

                    // Check if required fields exist
                    if (!post.containsKey('locationName') ||
                        !post.containsKey('latitude') ||
                        !post.containsKey('longitude')) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Error: Missing location data for this post.",
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    final LatLng postLocation = LatLng(
                      post['latitude'],
                      post['longitude'],
                    );

                    return GestureDetector(
                      onTap: () {
                        // Navigate to PostDetailScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostDetailScreen(post: post),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post['title'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Location: ${post['locationName']}",
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Rating: ${post['rating']} ⭐",
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Author: ${post['authorName']}",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
