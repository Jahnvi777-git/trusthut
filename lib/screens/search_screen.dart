import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'post_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchAuthor = '';
  String _searchLocation = '';
  String _searchTitle = '';
  double? _searchRating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Posts", style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search by Title
            TextField(
              decoration: InputDecoration(
                labelText: "Search by Title",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                setState(() {
                  _searchTitle = value.trim();
                });
              },
            ),
            SizedBox(height: 8),

            // Search by Author
            TextField(
              decoration: InputDecoration(
                labelText: "Search by Author",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                setState(() {
                  _searchAuthor = value.trim();
                });
              },
            ),
            SizedBox(height: 8),

            // Search by Location
            TextField(
              decoration: InputDecoration(
                labelText: "Search by Location",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                setState(() {
                  _searchLocation = value.trim();
                });
              },
            ),
            SizedBox(height: 8),

            // Search by Rating
            TextField(
              decoration: InputDecoration(
                labelText: "Search by Rating (e.g., 4.5)",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _searchRating = value.isEmpty ? null : double.tryParse(value);
                });
              },
            ),
            SizedBox(height: 16),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('posts').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: Color(0xFF664C36)));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No posts found.",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  }

                  final posts = snapshot.data!.docs.where((doc) {
                    final title = doc['title'].toString().toLowerCase();
                    final author = doc['authorName'].toString().toLowerCase();
                    final location = doc['location'].toString().toLowerCase();
                    final rating = doc['rating'];

                    return (title.contains(_searchTitle.toLowerCase()) || _searchTitle.isEmpty) &&
                        (author.contains(_searchAuthor.toLowerCase()) || _searchAuthor.isEmpty) &&
                        (location.contains(_searchLocation.toLowerCase()) || _searchLocation.isEmpty) &&
                        (_searchRating == null || rating == _searchRating);
                  }).toList();

                  if (posts.isEmpty) {
                    return Center(
                      child: Text(
                        "No posts match your search criteria.",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          tileColor: Theme.of(context).cardColor,
                          title: Text(
                            post['title'],
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text("Rating: ${post['rating']} ⭐", style: Theme.of(context).textTheme.bodyMedium),
                              Text("Location: ${post['location']}", style: Theme.of(context).textTheme.bodyMedium),
                              Text("Author: ${post['authorName']}", style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, color: Color(0xFF331C08)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostDetailScreen(post: post),
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
