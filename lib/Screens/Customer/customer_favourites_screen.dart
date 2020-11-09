import 'package:flutter/material.dart';

class FavouriteScreen extends StatelessWidget {
  ///Don't use Scaffold here. These 4 pages have one scaffold
  ///mentioned in main_screen.dart
  ///Other screens which does not need the bottom bar can have Scaffold
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Favourites Screen'),
    );
  }
}
