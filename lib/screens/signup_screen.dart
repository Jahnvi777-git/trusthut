import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_password != _confirmPassword) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Passwords do not match!")));
        return;
      }

      try {
        await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup successful! Please log in.")),
        );
        Navigator.pop(context); // Navigate back to LoginScreen
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Signup failed: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Signup"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Name"),
                onSaved: (value) => _name = value!.trim(),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? "Please enter your name"
                            : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _email = value!.trim(),
                validator:
                    (value) =>
                        value == null || !value.contains('@')
                            ? "Enter a valid email"
                            : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                onSaved: (value) => _password = value!.trim(),
                validator:
                    (value) =>
                        value == null || value.length < 6
                            ? "Password must be at least 6 characters"
                            : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Confirm Password"),
                obscureText: true,
                onSaved: (value) => _confirmPassword = value!.trim(),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? "Please confirm your password"
                            : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _signup, child: Text("Sign Up")),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Navigate back to LoginScreen
                },
                child: Text("Already have an account? Log in"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
