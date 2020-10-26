import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static String id = 'SplashScreen Id';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(children: [
              Image.asset('assets/splash.png'),
            ]),
          ),
        ),
      ),
    );
  }
}
