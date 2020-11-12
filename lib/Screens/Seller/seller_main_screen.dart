import 'package:aqua_ly/Screens/Seller/seller_home_screen.dart';
import 'package:aqua_ly/Screens/Seller/seller_orders_screen.dart';
import 'package:aqua_ly/Screens/Seller/seller_products_screen.dart';
import 'package:aqua_ly/Screens/Seller/seller_profile_screen.dart';
import 'package:aqua_ly/theme.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SellerMainScreen extends StatefulWidget {
  static String id = 'Seller Main Screen Id';

  @override
  _SellerMainScreenState createState() => _SellerMainScreenState();
}

class _SellerMainScreenState extends State<SellerMainScreen> {
  int currentIndex = 0;

  //Add Pages here
  List<Widget> pages = [
    SellerHomeScreen(),
    SellerProductScreen(),
    SellerOrdersScreen(),
    SellerProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hi, Seller'),
      ),
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
              icon: FontAwesomeIcons.sitemap, extras: {'label': 'Products'}),
          FluidNavBarIcon(
              icon: FontAwesomeIcons.clipboardList,
              extras: {'label': 'Orders'}),
          FluidNavBarIcon(
              icon: FontAwesomeIcons.user, extras: {'label': 'Profile'}),
        ],
      ),
    );
  }
}
