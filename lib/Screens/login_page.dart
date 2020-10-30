import 'package:aqua_ly/Screens/fish_info.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  static String id = 'login';
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Image.asset(
                'assets/graphics/logo-1.png',
                height: 150,
              ),
              const Text(
                "Welcome Back",
                style: TextStyle(color: Colors.blue, fontSize: 20),
              ),
              const Text(
                "Login to Continue",
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(10),
            child: Form(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  height: 50,
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        labelText: "Email",
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.red,
                        )),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  height: 50,
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        labelText: "Password",
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.black,
                        )),
                  ),
                ),
                FlatButton(
                  onPressed: () {},
                  child: const Text(
                    "Forgot Password?",
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                Container(
                  width: 300,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: RaisedButton(
                    onPressed: () => onLoginClick(context),
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      "LOGIN",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  "Don't have an account?",
                  style: TextStyle(fontSize: 10),
                  textAlign: TextAlign.right,
                ),
              ),
              FlatButton(
                  onPressed: null,
                  child: Text(
                    "Create an Account",
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ))
            ],
          )
        ],
      )),
    );
  }

  void onLoginClick(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, FishInfo.id, (route) => false);
  }
}
