import 'package:aqua_ly/Screens/Customer/main_screen.dart';
import 'package:aqua_ly/Screens/Seller/seller_main_screen.dart';
import 'package:aqua_ly/Screens/register_screen.dart';
import 'package:aqua_ly/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login';
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool hidePassword = true;
  bool isLoading = false;

  String email, pass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : createLoginForm(context));
  }

  SafeArea createLoginForm(BuildContext context) {
    return SafeArea(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Image.asset(
              'assets/graphics/logo-1.png',
              scale: 2,
            ),
            const Text(
              "Welcome Back",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24,
                  fontWeight: FontWeight.w600),
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
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //Email
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty || !EmailValidator.validate(value)) {
                        return 'Please enter valid email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        labelText: "Email",
                        prefixIcon: const Icon(
                          FontAwesomeIcons.solidEnvelope,
                          color: Colors.black54,
                        )),
                    onSaved: (input) => email = input,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(height: 20),
                  //Password
                  TextFormField(
                    obscureText: hidePassword,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'please enter password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        labelText: "Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          icon: Icon(hidePassword
                              ? FontAwesomeIcons.eye
                              : Icons.remove_red_eye),
                        ),
                        prefixIcon: const Icon(
                          FontAwesomeIcons.lock,
                          color: Colors.black54,
                        )),
                    onSaved: (input) => pass = input,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                  ),

                  //Forgot Password
                  FlatButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot Password?",
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),

                  //Login button
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

        //Redirect Register Button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                "Don't have an account?",
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.right,
              ),
            ),
            FlatButton(
                onPressed: () =>
                    Navigator.pushNamed(context, RegisterScreen.id),
                child: const Text(
                  "Create an Account",
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ))
          ],
        )
      ],
    ));
  }

  Future<void> onLoginClick(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      final FirebaseAuth _instance = FirebaseAuth.instance;
      //Logging in
      setState(() {
        isLoading = true;
      });
      try {
        final UserCredential credential = await _instance
            .signInWithEmailAndPassword(email: email, password: pass);
        final String uid = credential.user.uid;

        final _doc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (_doc.exists) {
          final _data = _doc.data();
          final String _type = _data['user_type'].toString();
          if (_type == 'Seller') {
            final int shopId = _data['shopId'] as int;
            SharedPrefs.saveNum('shopId', shopId);
          }
          final newRoute =
              _type == 'Seller' ? SellerMainScreen.id : MainScreen.id;
          final String userName = _data['name'] as String;

          await SharedPrefs.saveStr('name', userName);
          await SharedPrefs.saveStr('current_screen', newRoute);
          Navigator.of(context)
              .pushNamedAndRemoveUntil(newRoute, (route) => false);
        }
      }

      //Common errors
      on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'user-not-found':
            createSnackBar(
                'User Not found. Are you sure you registered with this email?');
            break;
          case 'wrong-password':
            createSnackBar('Wrong Password. Did you forget your password');
            break;
        }
      }

      //Unknown errors
      catch (e) {
        // ignore: avoid_print
        print(e);
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  void createSnackBar(String text) =>
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            text,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          )));
}
