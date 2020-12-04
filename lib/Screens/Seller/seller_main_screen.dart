import 'package:aqua_ly/Screens/Seller/seller_home_screen.dart';
import 'package:aqua_ly/Screens/Seller/seller_listing_screen.dart';
import 'package:aqua_ly/Screens/Seller/seller_orders_screen.dart';
import 'package:aqua_ly/Screens/Seller/seller_products_screen.dart';
import 'package:aqua_ly/Screens/Seller/seller_profile_screen.dart';
import 'package:aqua_ly/Screens/login_screen.dart';
import 'package:aqua_ly/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../shared_prefs.dart';

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
    SellerListingScreen(),
    SellerOrdersScreen(),
    SellerProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
            future: SharedPrefs.getSavedStr('name'),
            builder: (context, snapshot) {
              // 1 -> Error
              if (snapshot.hasError) {
                return const Text('Hi, Seller');
              }

              // 2 -> Success
              else if (snapshot.hasData) {
                return Text('Hi, ${snapshot.data}');
              }

              // 3 -> Loading
              else {
                return kLoading;
              }
            }),
        actions: [
          FlatButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, LoginScreen.id, (route) => false);
                SharedPrefs.clearAll();
              },
              icon: const Icon(
                FontAwesomeIcons.signOutAlt,
                color: Colors.white,
              ),
              label: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.white),
              ))
        ],
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
              icon: FontAwesomeIcons.archive, extras: {'label': 'Products'}),
          FluidNavBarIcon(
              icon: FontAwesomeIcons.list, extras: {'label': 'Listing'}),
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
