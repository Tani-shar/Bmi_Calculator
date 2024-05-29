// ignore_for_file: prefer_const_constructors


import 'package:flutter/material.dart';
import 'package:test_1/bmi_calculator.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:test_1/firebase_options.dart'; 

// import 'package:test_1/history.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); 
  runApp(MyApp()); 
} 


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Bmicalculator(),
      
    );
  }
}

 
