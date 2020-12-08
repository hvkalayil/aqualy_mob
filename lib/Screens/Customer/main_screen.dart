import 'package:aqua_ly/Screens/Customer/customer_cart_screen.dart';
import 'package:aqua_ly/Screens/Customer/customer_history_screen.dart';
import 'package:aqua_ly/Screens/Customer/customer_profile_screen.dart';
import 'package:aqua_ly/theme.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'customer_home_screen.dart';

class MainScreen extends StatefulWidget {
  static String id = 'CustomerMain Screen Id';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  //Add Pages here
  List<Widget> pages = [
    HomeScreen(),
    CartScreen(),
    HistoryScreen(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: FluidNavBar(
        style: const FluidNavBarStyle(
            iconUnselectedForegroundColor: Colors.white70,
            iconSelectedForegroundColor: Colors.white,
            barBackgroundColor: kPrimaryColor),
        onChange: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        icons: [
          FluidNavBarIcon(
              icon: FontAwesomeIcons.home, extras: {'label': 'Home'}),
          FluidNavBarIcon(
              icon: FontAwesomeIcons.shoppingCart, extras: {'label': 'Cart'}),
          FluidNavBarIcon(
              icon: FontAwesomeIcons.history, extras: {'label': 'History'}),
          FluidNavBarIcon(
              icon: FontAwesomeIcons.user, extras: {'label': 'Profile'}),
        ],
      ),
    );
  }
}
