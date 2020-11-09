import 'package:aqua_ly/Screens/Customer/customer_cart_screen.dart';
import 'package:aqua_ly/Screens/Customer/customer_favourites_screen.dart';
import 'package:aqua_ly/Screens/Customer/customer_profile_screen.dart';
import 'package:aqua_ly/theme.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

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
    ProfileScreen(),
    FavouriteScreen(),
    CartScreen()
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
          FluidNavBarIcon(icon: Icons.home, extras: {'label': 'Home'}),
          FluidNavBarIcon(icon: Icons.person, extras: {'label': 'Profile'}),
          FluidNavBarIcon(icon: Icons.book, extras: {'label': 'Favourites'}),
          FluidNavBarIcon(icon: Icons.category, extras: {'label': 'Cart'}),
        ],
      ),
    );
  }
}
