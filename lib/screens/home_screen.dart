import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Added FirebaseAuth import
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
    SearchTab(), // Search tab
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
        title: Text("TrustHut", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color(0xFFFFB6A0), // Peach for AppBar
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF4A90A4), // Teal for selected items
        unselectedItemColor: Color(0xFF2A3A4A), // Dark blue for unselected items
        backgroundColor: Color(0xFFEAF6F6), // Light blue for BottomNavigationBar
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
      color: Color(0xFFEAF6F6), // Light blue background for the Home Tab
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
                  color: Color(0xFF4A90A4), // Teal icon color
                ),
                SizedBox(height: 8),
                // TrustHut Text
                Text(
                  "Welcome to TrustHut!",
                  style: TextStyle(
                    fontSize: 24, // Increased font size
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2A3A4A), // Dark blue text
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  "Discover and share accessible locations for everyone, including the elderly and disabled. Together, we make the world more inclusive!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF2A3A4A), // Dark blue text
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                // Decorative Divider
                Divider(
                  color: Color(0xFF4A90A4), // Teal divider color
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
              stream: FirebaseFirestore.instance
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
                            builder: (context) => PostDetailScreen(
                              post: post,
                              postId: posts[index].id,
                            ),
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
                        color: Color(0xFF4A90A4), // Teal background for the card
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
                                  color: Color(0xFFFFFFFF), // White text
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Author: ${post['authorName']}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFFFFFFF), // White text
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Location: ${post['locationName']}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFFFFFFF), // White text
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Rating: ${post['rating']} ⭐",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFFFFFFFF), // White text
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          (post['likedBy'] != null &&
                                                  (post['likedBy'] as List)
                                                      .contains(
                                                        FirebaseAuth.instance
                                                            .currentUser
                                                            ?.uid,
                                                      ))
                                              ? Icons.thumb_up
                                              : Icons.thumb_up_outlined,
                                          color: Colors.amber,
                                        ),
                                        onPressed: () async {
                                          await toggleLike(
                                            posts[index].id,
                                            post,
                                          );
                                        },
                                      ),
                                      Text(
                                        "${post['likes'] ?? 0}", // Display the number of likes
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFFFFFFFF), // White text
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Description:",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFFFFF), // White text
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                post['description'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFFFFFFF), // White text
                                ),
                                maxLines: 3, // Limit to 3 lines
                                overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
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

Future<void> toggleLike(String postId, Map<String, dynamic> postData) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return; // Ensure the user is logged in

  final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);

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
}
