import 'package:firebase_core/firebase_core.dart';
import 'package:fitnessapp/signup.dart';
import 'package:flutter/material.dart';
import 'package:fitnessapp/login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.transparent, // Make background transparent
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg3.png'), // Your splash screen background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 200), // Move logo down more
              Image.asset(
                'assets/images/logo2.png',
                width: 300, // Increase logo width
                height: 300, // Increase logo height
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Make background transparent
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg3.png'), // Your main screen background image
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 300), // Move logo down more
            Image.asset(
              'assets/images/logo2.png',
              width: 300, // Increase logo width
              height: 300, // Increase logo height
            ),
            SizedBox(height: 1), // Add space between logo and buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40), // Add horizontal padding to buttons
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      );

                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, backgroundColor: Colors.orangeAccent, // Set text color to white
                      shape: RoundedRectangleBorder( // Make button rounded
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15), // Set vertical padding
                    ),
                    child: SizedBox( // Use SizedBox to set button width
                      width: double.infinity, // Set button width to match parent
                      child: Center( // Center the text in the button
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: 'Montserrat', // Set font to Montserrat
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Add space between buttons
                  OutlinedButton( // Use OutlinedButton for transparent button with outline
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );

                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.orangeAccent), // Add green outline
                      padding: EdgeInsets.symmetric(vertical: 15), // Set vertical padding
                      shape: RoundedRectangleBorder( // Make button rounded
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: SizedBox( // Use SizedBox to set button width
                      width: double.infinity, // Set button width to match parent
                      child: Center( // Center the text in the button
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontFamily: 'Montserrat', // Set font to Montserrat
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Set text color to white
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
