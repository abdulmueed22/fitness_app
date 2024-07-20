import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Your Workout'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WorkoutModeButton(
                mode: 'Gyming',
                icon: Icons.fitness_center,
                onPressed: () => _onWorkoutSelected(context, 'Gyming'),
              ),
              WorkoutModeButton(
                mode: 'Yoga',
                icon: Icons.self_improvement,
                onPressed: () => _onWorkoutSelected(context, 'Yoga'), // Corrected the workout mode name
              ),
              WorkoutModeButton(
                mode: 'Swimming',
                icon: Icons.pool,
                onPressed: () => _onWorkoutSelected(context, 'Swimming'),
              ),
              WorkoutModeButton(
                mode: 'Running',
                icon: Icons.directions_run,
                onPressed: () => _onWorkoutSelected(context, 'Running'),
              ),
              WorkoutModeButton(
                mode: 'Strolling',
                icon: Icons.directions_walk,
                onPressed: () => _onWorkoutSelected(context, 'Strolling'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onWorkoutSelected(BuildContext context, String selectedWorkout) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Workout selected: $selectedWorkout'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Store the chosen workout mode in Firestore
    _storeWorkoutMode(selectedWorkout);
  }

  void _storeWorkoutMode(String selectedWorkout) {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

        // Update the user document with the selected workout mode
        userDocRef.update({
          'workout_mode': selectedWorkout,
          'timestamp': FieldValue.serverTimestamp(),
        }).then((_) {
          print('Workout mode updated successfully');
        }).catchError((error) {
          print('Error updating workout mode: $error');
        });
      }
    } catch (e) {
      print('Error storing workout mode: $e');
    }
  }
}

class WorkoutModeButton extends StatelessWidget {
  final String mode;
  final IconData icon;
  final VoidCallback onPressed;

  WorkoutModeButton({
    required this.mode,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(mode),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orangeAccent,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
