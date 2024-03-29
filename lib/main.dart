import 'package:flutter/material.dart';
import 'package:vendor_app/auth/auth.dart';
import 'package:vendor_app/screens/homeScreen.dart';
// import 'package:vendor_app/auth/auth.dart';
// import 'package:vendor_app/screens/registerScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upkeep',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: LoginScreen(),
    );
  }
}
