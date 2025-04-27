import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trusthut/screens/post_detail_screen.dart';
import 'search_screen.dart';
import 'create_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    PostsTab(), // Home tab displaying posts
    SearchScreen(), // Search tab
    CreateScreen(), // Placeholder for Create tab
    ProfileScreen(), // Placeholder for Profile tab
  ];

  final List<String> _titles = ["Home", "Search", "Create", "Profile"];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex], // Dynamic title based on the selected tab
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Create'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class PostsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFFD3AC), // Light background for the Home Tab
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
                "No posts available.",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index].data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Color(0xFF331C08), // Dark background for each post
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
    );
  }
}
