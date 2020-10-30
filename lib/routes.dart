import 'package:aqua_ly/Screens/login_page.dart';
import 'package:aqua_ly/Screens/fish_info.dart';
import 'package:aqua_ly/Screens/splash_screen.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  SplashScreen.id: (_) => SplashScreen(),
  FishInfo.id: (_) => const FishInfo(),
  LoginPage.id: (_) => const LoginPage()
};
