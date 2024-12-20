import 'package:flutter/material.dart';
import 'package:health_app/Splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[50], // Light background
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black), // Updated for Flutter 3.0
          bodyMedium: TextStyle(color: Colors.black), // Updated for Flutter 3.0
          titleLarge: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
