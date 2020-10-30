import 'package:aqua_ly/Screens/LoginPage.dart';
import 'package:aqua_ly/Screens/fish_info.dart';
import 'package:aqua_ly/Screens/splash_screen.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  SplashScreen.id: (_) => SplashScreen(),
  fish_info.id: (_) => fish_info(),
  LoginPage.id: (_) => LoginPage()
};
