import 'package:aqua_ly/Api/api_handler.dart';
import 'package:aqua_ly/Screens/Customer/profile_setup_screen.dart';
import 'package:aqua_ly/Screens/Seller/seller_profile_setup_screen.dart';
import 'package:aqua_ly/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../shared_prefs.dart';

class RegisterScreen extends StatefulWidget {
  static String id = 'Register Screen Id';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool hidePassword = true;
  bool hideRePassword = true;
  bool isSeller = true;
  bool isLoading = false;

  String email, pass, rePass;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(elevation: 0),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : createRegisterForm(context));
  }

  SafeArea createRegisterForm(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Choose User type
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FlipAnimation(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: isSeller
                              ? kPrimaryColor.withOpacity(0.6)
                              : kPrimaryColor.withOpacity(0.4),
                          image: DecorationImage(
                              image: AssetImage(isSeller
                                  ? 'assets/graphics/SELLER.png'
                                  : 'assets/graphics/BUYER.png'))),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      makeUserTypeButton(seller: true),
                      makeUserTypeButton(seller: false),
                    ],
                  )
                ],
              ),

              //Registration Form
              Container(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Email
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty ||
                              !EmailValidator.validate(value)) {
                            return 'Please enter valid email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: "Email",
                            hintText: 'Enter your Email Address',
                            prefixIcon: const Icon(
                              FontAwesomeIcons.solidEnvelope,
                              color: Colors.black54,
                              size: 20,
                            )),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onSaved: (input) => email = input,
                      ),
                      const SizedBox(height: 20),

                      //Password
                      TextFormField(
                        obscureText: hidePassword,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: "Password",
                            hintText: 'Enter a secure password',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              icon: Icon(hidePassword
                                  ? FontAwesomeIcons.solidEyeSlash
                                  : FontAwesomeIcons.eye),
                              color: Colors.black54,
                              iconSize: 20,
                            ),
                            prefixIcon: const Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.black54,
                              size: 20,
                            )),
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (input) {
                          pass = input;
                          FocusScope.of(context).nextFocus();
                        },
                        onSaved: (input) => pass = input,
                      ),
                      const SizedBox(height: 20),

                      //Retype Password
                      TextFormField(
                        obscureText: hideRePassword,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter password';
                          } else if (value != pass) {
                            return "Passwords does'nt match";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: "Retype Password",
                            hintText: 'Retype the password',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hideRePassword = !hideRePassword;
                                });
                              },
                              icon: Icon(hideRePassword
                                  ? FontAwesomeIcons.solidEyeSlash
                                  : FontAwesomeIcons.eye),
                              color: Colors.black54,
                              iconSize: 20,
                            ),
                            prefixIcon: const Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.black54,
                              size: 20,
                            )),
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        onSaved: (input) => pass = input,
                      ),
                      const SizedBox(height: 20),

                      //Login button
                      Container(
                        width: 300,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: RaisedButton(
                          onPressed: () => onRegisterClick(context),
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text(
                            "REGISTER",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onRegisterClick(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        isLoading = true;
      });
      //Register User
      try {
        final UserCredential credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: pass);
        final String uid = credential.user.uid;

        await APIHandler.saveUid(uid);

        final String newRoute = isSeller
            ? SellerProfileSetupScreen.id
            : CustomerProfileSetupScreen.id;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({'user_type': newRoute});

        await SharedPrefs.saveStr('current_screen', newRoute);
        Navigator.of(context)
            .pushNamedAndRemoveUntil(newRoute, (route) => false);
      }

      //In case of common errors
      on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          createSnackBar('The password is too weak. Try Something else');
        } else if (e.code == 'email-already-in-use') {
          createSnackBar('The email is already registered. Try another email');
        }
      }

      //Other Unknown Errors
      catch (e) {
        Scaffold.of(context).showSnackBar(errorSnack(e.toString()));
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

  GestureDetector makeUserTypeButton({bool seller}) {
    final String img = seller ? 'sellerIcon.png' : 'customerIcon.png';
    final bool isActive = seller == isSeller;
    return GestureDetector(
      onTap: () {
        setState(() {
          isSeller = seller;
        });
      },
      child: Container(
        width: 100,
        height: 125,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            boxShadow: isActive
                ? [
                    BoxShadow(
                        color: kPrimaryColor.withOpacity(0.25),
                        spreadRadius: 2,
                        blurRadius: 4)
                  ]
                : [],
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/graphics/$img'),
            const SizedBox(height: 5),
            Text(
              seller ? 'Seller' : 'Customer',
              style: const TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
