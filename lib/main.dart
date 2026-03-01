import 'package:flutter/material.dart';
import 'screens/home_screen.dart' ;
import 'screens/calculator_screen.dart' ;
import 'screens/unit_converter_screen.dart';


void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CalciConvert',
      home: HomeScreen(),
    );
  }
}


