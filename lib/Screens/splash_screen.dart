import 'package:aqua_ly/Screens/login_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static String id = 'SplashScreen Id';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Future.delayed(const Duration(seconds: 2),
              () => Navigator.popAndPushNamed(context, LoginPage.id)),
          builder: (context, snapshot) {
            return SafeArea(
              child: Center(
                child: Column(children: [
                  Image.asset('assets/graphics/splash.png'),
                ]),
              ),
            );
          }),
    );
  }
}
