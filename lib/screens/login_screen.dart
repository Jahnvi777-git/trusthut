import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        // Authenticate the user with email and password
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Navigate to Home Page on successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TrustHut", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color(0xFFFFB6A0), // Peach for AppBar
        elevation: 0, // Flat AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Color(0xFF2A3A4A)), // Dark blue text
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || !value.contains('@') ? "Enter a valid email" : null,
              ),
              SizedBox(height: 16),

              // Password Field
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: Color(0xFF2A3A4A)), // Dark blue text
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) =>
                    value == null || value.isEmpty ? "Please enter your password" : null,
              ),
              SizedBox(height: 16),

              // Login Button
              ElevatedButton(
                onPressed: () => _login(context),
                child: Text("Login"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4A90A4), // Teal button color
                  foregroundColor: Colors.white, // White text
                ),
              ),
              SizedBox(height: 16),

              // Navigate to Sign Up Page
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                child: Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(color: Color(0xFF2A3A4A)), // Dark blue text
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFFEAF6F6), // Light blue background
    );
  }
}
