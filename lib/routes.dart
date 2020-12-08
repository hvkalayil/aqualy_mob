import 'package:aqua_ly/Screens/Seller/add_listing.dart';
import 'package:aqua_ly/Screens/Seller/add_product.dart';
import 'package:aqua_ly/Screens/Seller/edit_listing.dart';
import 'package:aqua_ly/Screens/Seller/seller_all_order_screen.dart';
import 'package:flutter/material.dart';

import 'Screens/Customer/main_screen.dart';
import 'Screens/Customer/profile_setup_screen.dart';
import 'Screens/Seller/seller_main_screen.dart';
import 'Screens/Seller/seller_profile_setup_screen.dart';
import 'Screens/login_screen.dart';
import 'Screens/register_screen.dart';
import 'Screens/splash_screen.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  SplashScreen.id: (_) => SplashScreen(),
  LoginScreen.id: (_) => const LoginScreen(),
  RegisterScreen.id: (_) => RegisterScreen(),

  //Customer Routes
  CustomerProfileSetupScreen.id: (_) => CustomerProfileSetupScreen(),
  MainScreen.id: (_) => MainScreen(),

  //Seller Routes
  SellerProfileSetupScreen.id: (_) => SellerProfileSetupScreen(),
  SellerMainScreen.id: (_) => SellerMainScreen(),
  AddProductScreen.id: (_) => AddProductScreen(),
  AddListingScreen.id: (_) => AddListingScreen(),
  EditListingScreen.id: (_) => const EditListingScreen(),
  SellerAllOrdersScreen.id: (_) => SellerAllOrdersScreen(),
};
