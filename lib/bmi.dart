import 'package:flutter/material.dart';

class CalculateBMIPage extends StatefulWidget {
  @override
  _CalculateBMIPageState createState() => _CalculateBMIPageState();
}

class _CalculateBMIPageState extends State<CalculateBMIPage> {
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  double _calculatedBMI = 0;

  double _calculateBMI() {
    double weightKg = double.tryParse(_weightController.text) ?? 0;
    double heightM = double.tryParse(_heightController.text) ?? 0;

    if (weightKg <= 0 || heightM <= 0) {
      return 0;
    }

    double bmi = weightKg / ((heightM / 100) * (heightM / 100));
    return bmi;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculate BMI'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter Your Height and Weight',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _heightController,
              decoration: InputDecoration(
                labelText: 'Height (in cm)',
                hintText: 'Enter your height in centimeters',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _weightController,
              decoration: InputDecoration(
                labelText: 'Weight (in kg)',
                hintText: 'Enter your weight in kilograms',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _calculatedBMI = _calculateBMI();
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.orangeAccent,
              ),
              child: Text('Calculate BMI'),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Your BMI: ${_calculatedBMI.toStringAsFixed(2)}',
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
