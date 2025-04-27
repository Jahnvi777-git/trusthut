import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'post_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchTitle = '';
  String _searchAuthor = '';
  String _searchLocation = '';
  double? _searchRating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search", style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search by Title
            TextField(
              decoration: InputDecoration(
                labelText: "Search by Title",
                filled: true,
                fillColor: Color(0xFFFFD3AC), // Light background for search bar
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchTitle = value.trim().toLowerCase();
                });
              },
            ),
            SizedBox(height: 8),

            // Search by Author
            TextField(
              decoration: InputDecoration(
                labelText: "Search by Author",
                filled: true,
                fillColor: Color(0xFFFFD3AC), // Light background for search bar
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchAuthor = value.trim().toLowerCase();
                });
              },
            ),
            SizedBox(height: 8),

            // Search by Location
            TextField(
              decoration: InputDecoration(
                labelText: "Search by Location",
                filled: true,
                fillColor: Color(0xFFFFD3AC), // Light background for search bar
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchLocation = value.trim().toLowerCase();
                });
              },
            ),
            SizedBox(height: 8),

            // Search by Rating
            TextField(
              decoration: InputDecoration(
                labelText: "Search by Rating (e.g., 4.5)",
                filled: true,
                fillColor: Color(0xFFFFD3AC), // Light background for search bar
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _searchRating = value.isEmpty ? null : double.tryParse(value);
                });
              },
            ),
            SizedBox(height: 16),

            // Search Results
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('posts')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No posts found.",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  }

                  final posts =
                      snapshot.data!.docs.where((doc) {
                        final title = doc['title'].toString().toLowerCase();
                        final author =
                            doc['authorName'].toString().toLowerCase();
                        final location =
                            doc['location'].toString().toLowerCase();
                        final rating = doc['rating'];

                        return (title.contains(_searchTitle) ||
                                _searchTitle.isEmpty) &&
                            (author.contains(_searchAuthor) ||
                                _searchAuthor.isEmpty) &&
                            (location.contains(_searchLocation) ||
                                _searchLocation.isEmpty) &&
                            (_searchRating == null || rating == _searchRating);
                      }).toList();

                  if (posts.isEmpty) {
                    return Center(
                      child: Text(
                        "No posts match your search.",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index].data() as Map<String, dynamic>;
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
                                "Author: ${post['authorName']}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFFFD3AC), // Light text
                                ),
                              ),
                            ],
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFFFFD3AC), // Light icon
                          ),
                          onTap: () {
                            // Navigate to PostDetailScreen
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
