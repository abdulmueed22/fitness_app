import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/signup.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Password Reset email has been sent!",
          style: TextStyle(fontSize: 18.0),
        ),
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "User does not exist!",
            style: TextStyle(fontSize: 18.0),
          ),
        ));
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
                'Password Recovery',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Color(0x30FFFFFF), // Semi-transparent white
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.black), // Border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.black), // Border color
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  resetPassword(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  'Send Email',
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
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>SignupPage()));
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
