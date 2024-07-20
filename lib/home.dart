import 'package:fitnessapp/leaderboard.dart';
import 'package:fitnessapp/notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fitnessapp/detailed_summary_page.dart';
import 'package:fitnessapp/caloriespage.dart';
import 'package:fitnessapp/bmi.dart';
import 'package:fitnessapp/workout.dart';
import 'package:fitnessapp/profilepage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _username = '';
  String _stepCount = '0';
  late Stream<StepCount> _stepCountStream;

  @override
  void initState() {
    super.initState();
    _fetchUsername();
    _requestPermissions();
  }

  void _fetchUsername() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userId = user.uid;
        DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
        String fullName = snapshot['full_name'];

        setState(() {
          _username = fullName;
        });
      }
    } catch (e) {
      print('Error fetching username: $e');
    }
  }

  Future<void> _requestPermissions() async {
    if (await Permission.activityRecognition.request().isGranted) {
      _initializePedometer();
    }
  }

  void _initializePedometer() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(_onStepCount).onError(_onStepCountError);
  }

  void _onStepCount(StepCount event) {
    setState(() {
      _stepCount = event.steps.toString();
    });
    _storeStepData(event.steps);
  }

  void _onStepCountError(error) {
    print('Step Count Error: $error');
    setState(() {
      _stepCount = 'N/A';
    });
  }

  double _calculateMiles(int steps) {
    return steps * 2.5 / 5280;
  }

  double _calculateCaloriesBurned(int steps) {
    return steps * 0.04;
  }

  void _storeStepData(int steps) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        double miles = _calculateMiles(steps);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('daily_steps')
            .doc(_getCurrentDate())
            .set({
          'steps': steps,
          'miles': miles,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error storing step data: $e');
    }
  }

  String _getCurrentDate() {
    final DateTime now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  @override
  Widget build(BuildContext context) {
    int steps = int.tryParse(_stepCount) ?? 0;
    double miles = _calculateMiles(steps);
    double calories = _calculateCaloriesBurned(steps);
    return Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
        body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        Container(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
    bottomLeft: Radius.circular(20),
    bottomRight: Radius.circular(20),
    ),
    boxShadow: [
    BoxShadow(
    color: Colors.black26,
    blurRadius: 10,
    spreadRadius: 1,
    offset: Offset(0, 2),
    ),
    ],
    ),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Padding(
    padding: const EdgeInsets.only(left: 20),
    child: Text(
    'Hello, $_username',
    style: TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    IconButton(
    onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationsPage()),);
    },
    icon: Icon(Icons.notifications_outlined),
    ),
    ],
    ),
    ),
    SizedBox(height: 20),
    Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Colors.grey[300],
    ),
    width: MediaQuery.of(context).size.width - 40,
    height: 220,
    child: ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Image.asset(
    'assets/images/bg3.png',
    width: double.infinity,
    height: double.infinity,
    fit: BoxFit.fill,
    ),
    ),
    ),
    SizedBox(height: 20),
    Text(
    'Health Summary',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    textAlign: TextAlign.center,
    ),
    SizedBox(height: 30),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
    _buildHealthMetricHeading('Steps Count', Icons.directions_walk),
    _buildHealthMetricHeading('Calories Intake', Icons.local_fire_department),
    ],
    ),
    SizedBox(height: 30),
    Expanded(
    child: Center(
    child: GestureDetector(
    onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => CalculateBMIPage(),
    ),
    );
    },
    child: Container(
    width: MediaQuery.of(context).size.width - 180,
    height: 100,
    child: _buildHealthMetricHeading('BMI', Icons.accessibility_new_rounded),
    ),
    ),
    ),
    ),
    Expanded(
    child: Container(),
    ),
    ],
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    bottomNavigationBar: Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavBarIcon(Icons.home_outlined, Icons.home, 0, null),
          _buildNavBarIcon(Icons.fitness_center_outlined, Icons.fitness_center, 1, WorkoutPage()),
          _buildNavBarIcon(Icons.leaderboard_outlined, Icons.leaderboard, 2, LeaderboardPage()),
          _buildNavBarIcon(Icons.person_outline, Icons.person, 3, ProfilePage()),
        ],
      ),
    ),
    );
  }

  Widget _buildHealthMetricHeading(String label, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (label == 'Steps Count') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailedSummaryPage(
                steps: _stepCount,
                miles: _calculateMiles(int.parse(_stepCount)),
                calories: _calculateCaloriesBurned(int.parse(_stepCount)),
              ),
            ),
          );
        } else if (label == 'Calories Intake') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CalculateCaloriesPage(),
            ),
          );
        } else if (label == 'BMI') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CalculateBMIPage(),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.orangeAccent,
              size: 30,
            ),
            SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarIcon(IconData outlinedIcon, IconData filledIcon, int index, Widget? page) {
    Color iconColor = _selectedIndex == index ? Colors.orangeAccent : Colors.grey;
    IconData icon = _selectedIndex == index ? filledIcon : outlinedIcon;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _selectedIndex = index;
            });
            if (page != null) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => page));
            }
          },
          icon: Icon(icon),
          color: iconColor,
        ),
        if (_selectedIndex == index)
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orangeAccent,
            ),
          ),
      ],
    );
  }
}
