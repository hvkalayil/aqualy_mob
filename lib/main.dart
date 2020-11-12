
import 'package:aqua_ly/Screens/Customer/main_screen.dart';
import 'package:aqua_ly/Screens/Seller/seller_profile_setup_screen.dart';
import 'package:aqua_ly/routes.dart';
import 'package:aqua_ly/theme.dart';
import 'package:flutter/material.dart';
import 'Screens/Customer/fish_info_screen.dart';
import 'Screens/Customer/main_screen.dart';
import 'Screens/Customer/profile_setup_screen.dart';
import 'Screens/Customer/profile_setup_screen.dart';
import 'Screens/Seller/seller_main_screen.dart';
import 'Screens/login_screen.dart';
import 'Screens/register_screen.dart';
import 'Screens/splash_screen.dart';
void main() {
  runApp(Aqualy());
}

class Aqualy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aqua.ly',
      theme: appTheme,
      initialRoute: SellerProfileSetupScreen.id,
      routes: routes,
    );
  }
}
