import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnessapp/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;
  DocumentSnapshot<Map<String, dynamic>>? _userDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      _user = FirebaseAuth.instance.currentUser;
      if (_user != null) {
        DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .get();
        if (snapshot.exists) {
          setState(() {
            _userDetails = snapshot;
            _isLoading = false;
          });
        } else {
          print('Document does not exist');
        }
      } else {
        print('User is not logged in');
      }
    } catch (e) {
      print('Error fetching user details: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Center(
                child: Container(
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Image.network(
                      "https://preview.redd.it/i-was-doing-a-pfp-for-myself-but-i-had-to-share-v0-4dzgwzzha7ha1.png?width=640&crop=smart&auto=webp&s=936d81670b931590c6c7c609a4a3e8e5ddfc1d9a",
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, object, stack) {
                        return Container(
                          child: Icon(Icons.error_outline, color: Colors.red),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : _userDetails == null
                  ? Text('No user details available')
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Personal Details:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildDetailItemWithIcon(Icons.person, 'Full Name', _userDetails!['full_name'] ?? 'No Name'),
                  _buildDetailItemWithIcon(Icons.access_time, 'Age', _userDetails!['age'] ?? 'No Age'),
                  _buildDetailItemWithIcon(Icons.calendar_today, 'Date of Birth', _userDetails!['dob'] ?? 'No Date of Birth'),
                  _buildDetailItemWithIcon(Icons.email, 'Email', _userDetails!['email'] ?? 'No Email'),
                  _buildDetailItemWithIcon(Icons.phone, 'Phone', _userDetails!['phone'] ?? 'No Phone'),
                ],
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()), // Replace 'MainScreen()' with your main screen widget
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.orangeAccent,
                  ),
                  child: Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItemWithIcon(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
