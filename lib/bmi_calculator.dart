import 'package:flutter/material.dart';
import 'package:test_1/history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Bmicalculator extends StatefulWidget {
  const Bmicalculator({super.key});

  @override
  State<Bmicalculator> createState() => _Bmicalculator();
}

class _Bmicalculator extends State<Bmicalculator> {
  double bmi = 0;
  var backgroundColor = Colors.blueGrey;
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController textEditingController2 = TextEditingController();

  void calculateBMI() {
    double weight = double.parse(textEditingController.text);
    double height = double.parse(textEditingController2.text);

    // Calculate BMI using the formula
    bmi = weight / (height * height);

    // Now you can use the BMI for further processing or display
    if (bmi < 25 && bmi > 17) {
      backgroundColor = Colors.green;
    } else if (bmi > 25) {
      backgroundColor = Colors.red;
    } else {
      backgroundColor = Colors.blue;
    }
    // You might want to update the UI or state if needed
    setState(() {
      // Update any UI elements or variables as needed
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: const BorderSide(
        width: 2.0,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.circular(5),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 81, 197, 255),
        elevation: 0,
        title: const Text('Bmi Calculator',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                
                bmi.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 55,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              TextField(
                controller: textEditingController,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter weight in KGs',
                  hintStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  prefixIcon: const Icon(Icons.scale),
                  prefixIconColor: Colors.black,
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: border,
                  enabledBorder: border,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: textEditingController2,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter height in metres',
                  hintStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  prefixIcon: const Icon(Icons.format_list_numbered),
                  prefixIconColor: Colors.black,
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: border,
                  enabledBorder: border,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  calculateBMI();
                  FirebaseFirestore.instance
                      .collection('history')
                      .add({
                        'height': textEditingController2.text,
                        'weight': textEditingController.text, 
                        'bmi': bmi,
                        'timestamp': FieldValue.serverTimestamp(),
                        }, );
                      
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text('calculate'),
              ),
              const SizedBox(height: 50,),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LoginScreen();
                  }));
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
