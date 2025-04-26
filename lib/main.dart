import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
      theme: ThemeData(
        primaryColor: Color(0xFF331C08), // Dark brown for primary elements
        scaffoldBackgroundColor: Color(
          0xFFFFD3AC,
        ), // Light peach for background
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF331C08),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF331C08),
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF331C08),
          ),
          bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF331C08)),
          bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF331C08)),
        ),
        cardColor: Color(0xFFCCBEB1), // Beige for cards
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF664C36), // Medium brown for buttons
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF331C08),
          selectedItemColor: Color(
            0xFFFFD3AC,
          ), // Light peach for selected items
          unselectedItemColor: Color(0xFFCCBEB1), // Beige for unselected items
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
