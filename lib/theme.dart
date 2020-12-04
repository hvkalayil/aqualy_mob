import 'package:flutter/material.dart';

ThemeData appTheme =
    ThemeData(primaryColor: const Color(0xff379DD7), fontFamily: 'Mont');

const Color kPrimaryColor = Color(0xff379DD7);

SnackBar errorSnack(String msg) => SnackBar(
      content: Text(msg),
      backgroundColor: Colors.redAccent,
    );

const Center kLoading = Center(
  child: CircularProgressIndicator(
    backgroundColor: Colors.white,
  ),
);

Center kError(String msg, {TextStyle style = const TextStyle()}) => Center(
      child: Text(
        msg,
        style: style,
        textAlign: TextAlign.center,
      ),
    );

const String kDefImg = 'assets/graphics/fish1.png';
const String kDefProfile = 'assets/graphics/male.png';
