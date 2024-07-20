import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.leaderboard, size: 30, color: Colors.orange),
                SizedBox(width: 10),
                Text(
                  'Leaderboard',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              padding: EdgeInsets.all(20),
              children: [
                _buildLeaderboardItem('Hassan Raza', 1500),
                _buildLeaderboardItem('Rehan Ahmed', 1400),
                _buildLeaderboardItem('Abdullah Ashraf', 1300),
                _buildLeaderboardItem('Wasif Ali', 1200),
                _buildLeaderboardItem('Khalfan Khan', 1100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem(String name, int score) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Score: $score',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

