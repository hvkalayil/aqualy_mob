import 'package:aqua_ly/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: kPrimaryColor.withOpacity(0.2),
                        image: DecorationImage(
                            image: AssetImage(isSeller
                                ? 'assets/graphics/sellerImg.png'
                                : 'assets/graphics/customerImg.png'))),
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
                              Icons.email,
                              color: Colors.red,
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
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.remove_red_eye),
                            ),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.black,
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
                              icon: Icon(hidePassword
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.remove_red_eye),
                            ),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.black,
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

        final String newRoute = isSeller ? 'Seller' : 'Customer';
        FirebaseFirestore.instance
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
        Scaffold.of(context).showSnackBar(
            const SnackBar(content: Text('Unknown Error occured')));
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
