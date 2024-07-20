import 'package:fitnessapp/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnessapp/login.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  void _signup() async {
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'full_name': _fullNameController.text.trim(),
          'age': _ageController.text.trim(),
          'dob': _dobController.text.trim(),
          'phone': _phoneController.text.trim(),
          'email': _emailController.text.trim(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registered successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate to the main screen or login screen after successful registration
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MainScreen()));
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Create an Account',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
              ),
              SizedBox(height: 10.0),
              buildInputField(Icons.person, 'Full Name', _fullNameController),
              SizedBox(height: 10.0),
              buildInputField(
                  Icons.calendar_today, 'Date of Birth', _dobController),
              SizedBox(height: 10.0),
              buildInputField(Icons.phone, 'Phone Number', _phoneController),
              SizedBox(height: 10.0),
              buildInputField(Icons.email, 'Email', _emailController),
              SizedBox(height: 10.0),
              buildInputField(Icons.lock, 'Password', _passwordController,
                  obscureText: true),
              SizedBox(height: 10.0),
              buildInputField(
                  Icons.lock, 'Confirm Password', _confirmPasswordController,
                  obscureText: true),
              SizedBox(height: 10.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _signup();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0), // Add some space between the button and the text
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text(
                  'If you have an account, Login',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(IconData icon, String label,
      TextEditingController controller,
      {bool obscureText = false}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
        border: Border.all(color: Colors.black),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.black,
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                border: InputBorder.none,
                labelStyle: TextStyle(color: Colors.black),
                hintStyle: TextStyle(color: Colors.black),
              ),
              style: TextStyle(color: Colors.black),
              cursorColor: Colors.black,
              obscureText: obscureText,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter $label';
                }
                if (label == 'Email' && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                if (label == 'Password' && value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                if (label == 'Confirm Password' && value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
