import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          _buildNotificationCard(
              'New Workout Plan Available',
              'Check out our new 4-week HIIT workout plan to boost your fitness journey.'),
          _buildNotificationCard(
              'Weekly Progress Report',
              'You\'ve burned 1,500 calories this week. Keep up the great work!'),
          _buildNotificationCard(
              'Challenge Completed',
              'Congratulations! You have completed the 10,000 steps daily challenge.'),
          _buildNotificationCard(
              'Hydration Reminder',
              'Remember to drink 8 glasses of water today for optimal hydration.'),
          _buildNotificationCard(
              'Fitness Goal Achieved',
              'Awesome job! You have reached your target weight.'),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(String title, String detail) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              detail,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}

