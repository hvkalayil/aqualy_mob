import 'package:aqua_ly/Screens/register_screen.dart';
import 'package:aqua_ly/routes.dart';
import 'package:aqua_ly/theme.dart';
import 'package:flutter/material.dart';

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
      initialRoute: RegisterScreen.id,
      routes: routes,
    );
  }
}
