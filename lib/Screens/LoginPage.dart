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
              Text(
                "Welcome Back",
                style: TextStyle(color: Colors.blue, fontSize: 20),
              ),
              Text(
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
                        prefixIcon: Icon(
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
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.black,
                        )),
                  ),
                ),
                FlatButton(
                  onPressed: () {},
                  child: Text(
                    "Forgot Password?",
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                Container(
                  width: 300,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: RaisedButton(
                    onPressed: () {},
                    color: Colors.blue,
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                )
              ],
            )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
}
