import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trusthut/screens/post_detail_screen.dart';
import 'search_screen.dart';
import 'create_screen.dart' as create;
import 'package:trusthut/screens/profile_screen.dart'; // Ensure this file defines ProfileScreen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    PostsTab(), // Home tab displaying posts
    SearchScreen(), // Search tab
    create.CreateScreen(), // Placeholder for Create tab
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TrustHut Description
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Decorative Icon
                Icon(
                  Icons.location_on,
                  size: 40,
                  color: Color(0xFF331C08), // Dark icon color
                ),
                SizedBox(height: 8),
                // TrustHut Text
                Text(
                  "Welcome to TrustHut!",
                  style: TextStyle(
                    fontSize: 24, // Increased font size
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF331C08), // Dark text
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  "Discover and share accessible locations for everyone, including the elderly and disabled. Together, we make the world more inclusive!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF331C08), // Dark text
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                // Decorative Divider
                Divider(
                  color: Color(0xFF331C08),
                  thickness: 1.5,
                  indent: 50,
                  endIndent: 50,
                ),
              ],
            ),
          ),

          // Posts Carousel
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
                      "No posts available.",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                }

                final posts = snapshot.data!.docs;

                return PageView.builder(
                  itemCount: posts.length,
                  controller: PageController(viewportFraction: 0.8),
                  itemBuilder: (context, index) {
                    final post = posts[index].data() as Map<String, dynamic>;

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
                        color: Color(
                          0xFF331C08,
                        ), // Dark background for the card
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post['title'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFD3AC), // Light text
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Author: ${post['authorName']}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFFFD3AC),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Location: ${post['location']}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFFFD3AC),
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    "Rating: ${post['rating']} ⭐",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFFFFD3AC),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Description:",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFD3AC),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                post['description'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFFFD3AC),
                                ),
                                maxLines: 3, // Limit to 3 lines
                                overflow:
                                    TextOverflow
                                        .ellipsis, // Add ellipsis if text overflows
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
