import 'package:aqua_ly/Screens/splash_screen.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  SplashScreen.id: (_) => SplashScreen()
};
