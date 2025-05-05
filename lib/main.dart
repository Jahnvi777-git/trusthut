import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart'; // Import the splash screen
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAWLIxzE3kHFftqq2MwJPeSM3MLKkIZS5o",
      authDomain: "trusthut-6e4a2.firebaseapp.com",
      projectId: "trusthut-6e4a2",
      storageBucket: "trusthut-6e4a2.appspot.com",
      messagingSenderId: "259726484715",
      appId: "1:259726484715:web:154d4841883ab2f49b0aae",
      measurementId: "G-XEVK4V5734",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrustHut',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   primaryColor: Color(0xFF331C08), // Dark brown for primary elements
      //   scaffoldBackgroundColor: Color(0xFFFFD3AC), // Light peach for background
      //   appBarTheme: AppBarTheme(
      //     backgroundColor: Color(0xFF331C08), // Dark brown for AppBar
      //     foregroundColor: Colors.white, // White text for AppBar
      //     elevation: 0,
      //   ),
      //   textTheme: TextTheme(
      //     displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF331C08)),
      //     titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF331C08)),
      //     bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF331C08)),
      //     bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF331C08)),
      //   ),
      //   cardColor: Color(0xFF664C36), // Medium brown for cards
      //   elevatedButtonTheme: ElevatedButtonThemeData(
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: Color(0xFF331C08), // Dark brown for buttons
      //       foregroundColor: Colors.white, // White text for buttons
      //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      //     ),
      //   ),
      //   bottomNavigationBarTheme: BottomNavigationBarThemeData(
      //     backgroundColor: Color(0xFFFFD3AC), // Light cream color for BottomNavigationBar
      //     selectedItemColor: Color(0xFF331C08), // Dark brown for selected items
      //     unselectedItemColor: Color(0xFF664C36), // Medium brown for unselected items
      //   ),
      // ),
      theme: ThemeData(
        primaryColor: Color(0xFFFFB6A0), // Peach for primary elements
        scaffoldBackgroundColor: Color(0xFFEAF6F6), // Light blue for background
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFFFB6A0), // Peach for AppBar
          foregroundColor: Color(0xFF2A3A4A), // Dark blue for AppBar text
          elevation: 0,
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2A3A4A), // Dark blue for headings
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2A3A4A), // Dark blue for titles
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFF2A3A4A), // Dark blue for body text
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFF2A3A4A), // Dark blue for smaller text
          ),
        ),
        cardColor: Color(0xFFFFFFFF), // White for cards
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF4A90A4), // Teal for buttons
            foregroundColor: Color(0xFFFFFFFF), // White text for buttons
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFEAF6F6), // Light blue for BottomNavigationBar
          selectedItemColor: Color(0xFF4A90A4), // Teal for selected items
          unselectedItemColor: Color(0xFF2A3A4A), // Dark blue for unselected items
        ),
      ),
      initialRoute: '/', // Set the initial route
      routes: {
        '/': (context) => SplashScreen(), // Splash screen as the initial route
        '/login': (context) => LoginScreen(), // Login screen
        '/home': (context) => HomeScreen(), // Home screen
      },
    );
  }
}