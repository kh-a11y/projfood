import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProjFood',
      theme: ThemeData(primarySwatch: Colors.orange, fontFamily: 'Roboto'),
      home: const SplashScreen(),
    );
  }
}
