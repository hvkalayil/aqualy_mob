import 'package:aqua_ly/Screens/login_screen.dart';
import 'package:aqua_ly/shared_prefs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static String id = 'SplashScreen Id';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return SingleChildScrollView(
                child: FutureBuilder(
                    future:
                        Future.delayed(const Duration(seconds: 1), () async {
                      final String route =
                          await SharedPrefs.getSavedStr('current_screen') ??
                              LoginScreen.id;
                      Navigator.popAndPushNamed(context, route);
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return SafeArea(
                          child: Center(
                            child: Image.asset('assets/graphics/splash.png'),
                          ),
                        );
                      }
                    }),
              );
            }
          }),
    );
  }
}
