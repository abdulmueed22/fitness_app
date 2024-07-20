import 'package:flutter/material.dart';

class CalculateCaloriesPage extends StatefulWidget {
  @override
  _CalculateCaloriesPageState createState() => _CalculateCaloriesPageState();
}

class _CalculateCaloriesPageState extends State<CalculateCaloriesPage> {
  List<Map<String, dynamic>> _foodItems = [
    {'name': 'Apple', 'calories': 52},
    {'name': 'Banana', 'calories': 89},
    {'name': 'Chicken Breast', 'calories': 165},
    {'name': 'Salmon Fillet', 'calories': 206},
    {'name': 'Pasta (1 cup)', 'calories': 221},
    {'name': 'Rice (1 cup)', 'calories': 206},
  ];

  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    // Initialize text editing controllers
    _foodItems.forEach((food) {
      _controllers.add(TextEditingController());
    });
  }

  @override
  void dispose() {
    // Dispose text editing controllers
    _controllers.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  int _calculateTotalCalories() {
    int totalCalories = 0;
    for (int i = 0; i < _foodItems.length; i++) {
      int quantity = int.tryParse(_controllers[i].text) ?? 0;
      int calories = _foodItems[i]['calories'] * quantity;
      totalCalories += calories;
    }
    return totalCalories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculate Calories'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Food Items',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _foodItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _controllers[index],
                    decoration: InputDecoration(
                      labelText: _foodItems[index]['name'],
                      hintText: 'Enter quantity',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
              ),
              child: Text(
                'Calculate Total Calories',
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Total Calories: ${_calculateTotalCalories()}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
