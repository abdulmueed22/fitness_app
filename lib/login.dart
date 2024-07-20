import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/Home.dart';
import 'package:fitnessapp/forgotpassword.dart';
import 'package:fitnessapp/signup.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signIn(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Navigate to home page if login is successful
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        // Show error message if user is not found or password is incorrect
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid email or password')));
      } else {
        // Show other error messages
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'An error occurred')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white12, // Background color
              Colors.white12, // Background color
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Text color
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black), // Label text color
                  filled: true,
                  fillColor: Color(0x30FFFFFF), // Semi-transparent white
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.black), // Outline border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.black), // Outline border color
                  ),
                  prefixIcon: Icon(Icons.email, color: Colors.black), // Email icon
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.black), // Label text color
                  filled: true,
                  fillColor: Color(0x30FFFFFF), // Semi-transparent white
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.black), // Outline border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.black), // Outline border color
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.black), // Lock icon
                ),
              ),
              SizedBox(height: 10), // Reduced space here
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>ForgotPassword()),);
                  },
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(color: Colors.black), // Text color
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  signIn(context); // Call the signIn method when the login button is pressed
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent, // Change button color to orange accent
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.black, // Text color
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>SignupPage()),
                  );
                },
                child: Text(
                  'Don\'t have an account? Sign Up',
                  style: TextStyle(
                    color: Colors.black, // Text color
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
