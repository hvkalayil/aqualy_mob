import 'package:flutter/material.dart';

import 'Screens/Customer/fish_info_screen.dart';
import 'Screens/Customer/main_screen.dart';
import 'Screens/Customer/profile_setup_screen.dart';
import 'Screens/Seller/seller_main_screen.dart';
import 'Screens/Seller/seller_profile_setup_screen.dart';
import 'Screens/login_screen.dart';
import 'Screens/register_screen.dart';
import 'Screens/splash_screen.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  //Common Routes
  SplashScreen.id: (_) => SplashScreen(),
  FishInfoScreen.id: (_) => const FishInfoScreen(),
  LoginScreen.id: (_) => const LoginScreen(),
  RegisterScreen.id: (_) => RegisterScreen(),

  //Customer Routes

  CustomerProfileSetupScreen.id: (_) => CustomerProfileSetupScreen(),
  MainScreen.id: (_) => MainScreen(),

  //Seller Routes
  SellerProfileSetupScreen.id: (_) => SellerProfileSetupScreen(),
  SellerMainScreen.id: (_) => SellerMainScreen(),
};
