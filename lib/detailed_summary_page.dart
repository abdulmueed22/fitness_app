import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailedSummaryPage extends StatelessWidget {
  final String steps;
  final double miles;
  final double calories;

  DetailedSummaryPage({required this.steps, required this.miles, required this.calories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detailed Summary'),
        backgroundColor: Colors.white, // Set app bar background color to white
      ),
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue, Colors.purple], // Adjust gradient colors as needed
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<DocumentSnapshot>(
              future: _fetchStepData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text('No data available'));
                }
                var data = snapshot.data!.data() as Map<String, dynamic>;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeading('Daily Summary'),
                      SizedBox(height: 20),
                      _buildMetricContainer('Steps', data['steps'].toString(), Icons.directions_walk, width: 400), // Increased width
                      SizedBox(height: 20),
                      _buildMetricContainer('Miles Walked', '${data['miles'].toStringAsFixed(2)} miles', Icons.directions_run, width: 400), // Increased width
                      SizedBox(height: 20),
                      _buildMetricContainer('Calories Burned', '${(data['steps'] * 0.04).toStringAsFixed(2)} cal', Icons.local_fire_department, width: 400), // Increased width
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeading(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Adjust text color to be visible on gradient background
        ),
      ),
    );
  }

  Widget _buildMetricContainer(String title, String value, IconData icon, {double width = 300}) {
    return Container(
      width: double.infinity, // Expand container to full width
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 30,
                color: Colors.orangeAccent,
              ),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Future<DocumentSnapshot> _fetchStepData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      return await FirebaseFirestore.instance.collection('users').doc(userId).collection('daily_steps').doc(_getCurrentDate()).get();
    }
    return Future.error('No user logged in');
  }

  String _getCurrentDate() {
    final DateTime now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }
}
