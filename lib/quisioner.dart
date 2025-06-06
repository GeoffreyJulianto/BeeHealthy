import 'package:flutter/material.dart';
import 'questions.dart'; // adjust if path is different

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sleep Survey',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SleepSurveyBundle(), // This shows your bundled survey
    );
  }
}
