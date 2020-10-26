import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static String id = 'SplashScreen Id';
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Lorem Ipsum',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}