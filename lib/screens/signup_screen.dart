import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String _name = '';
  String _email = '';
  String _password = '';

  void _signUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Create a new user with email and password
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _email,
          password: _passwordController.text,
        );

        // Update the user's display name
        await userCredential.user!.updateDisplayName(_name);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign up successful! Please log in.')),
        );

        // Navigate to Login Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Sign up failed: $e')));
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
              // Name Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(color: Color(0xFF2A3A4A)), // Dark blue text
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _name = value!.trim(),
                validator: (value) =>
                    value == null || value.isEmpty ? "Please enter your name" : null,
              ),
              SizedBox(height: 16),

              // Email Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Color(0xFF2A3A4A)), // Dark blue text
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _email = value!.trim(),
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
                    value == null || value.length < 6
                        ? "Password must be at least 6 characters"
                        : null,
              ),
              SizedBox(height: 16),

              // Re-type Password Field
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: "Re-type Password",
                  labelStyle: TextStyle(color: Color(0xFF2A3A4A)), // Dark blue text
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please re-type your password";
                  }
                  if (value != _passwordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Sign Up Button
              ElevatedButton(
                onPressed: () => _signUp(context),
                child: Text("Sign Up"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4A90A4), // Teal button color
                  foregroundColor: Colors.white, // White text
                ),
              ),
              SizedBox(height: 16),

              // Navigate to Login Page
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text(
                  "Already have an account? Login",
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
