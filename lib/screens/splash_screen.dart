import 'package:flutter/material.dart';
import 'dart:async';
import 'login_screen.dart'; // Import the login screen

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the login screen after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFD3AC), // Light peach background
      body: Center(
        child: Image.asset(
          'lib/assets/images/splash_image.png', // Path to your splash image
          // width: 200, // Adjust the width as needed
          height: 500, // Adjust the height as needed
        ),
      ),
    );
  }
}
