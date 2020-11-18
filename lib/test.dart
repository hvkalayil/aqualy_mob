import 'package:aqua_ly/Api/api_handler.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  static String id = 'Test';
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  void initState() {
    super.initState();
    initJobs();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Testing'),
      ),
    );
  }

  Future<void> initJobs() async {
    await APIHandler.getShopIdForNewUser();
  }
}
