import 'dart:io';

import 'package:aqua_ly/Api/api_handler.dart';
import 'package:aqua_ly/Screens/Seller/seller_main_screen.dart';
import 'package:aqua_ly/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import '../../theme.dart';

class SellerProfileSetupScreen extends StatefulWidget {
  static String id = 'Seller';

  @override
  _SellerProfileSetupScreenState createState() =>
      _SellerProfileSetupScreenState();
}

class _SellerProfileSetupScreenState extends State<SellerProfileSetupScreen> {
  PickedFile _imageFile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final ImagePicker _picker = ImagePicker();
  static const kSmallSpacing = SizedBox(height: 10);
  static const kBigSpacing = SizedBox(height: 20);
  String name, mobile, location, company;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Heading 1
                  const Text(
                    "Welcome",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                        color: kPrimaryColor),
                  ),

                  //Heading 2
                  const Text(
                    "Setup a Seller profile to continue",
                    style: TextStyle(color: Colors.grey),
                  ),

                  kBigSpacing,
                  //Profile Image & Edit Button
                  Stack(
                    children: [
                      //Profile Image
                      CircleAvatar(
                        backgroundColor: kPrimaryColor,
                        radius: 80,
                        child: Container(
                          height: 140,
                          decoration: _imageFile == null
                              ? const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/graphics/male.png'),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: FileImage(File(_imageFile.path)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),

                      //Edit Button
                      Positioned(
                        bottom: 0,
                        right: -10,
                        child: RaisedButton(
                            color: Colors.white,
                            padding: const EdgeInsets.all(16),
                            shape: const CircleBorder(),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (builder) => buildBottomOverlay());
                            },
                            child: const Icon(
                              FontAwesomeIcons.camera,
                              color: kPrimaryColor,
                              size: 20,
                            )),
                      )
                    ],
                  ),
                  kBigSpacing,

                  //Form
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          //Name
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                FontAwesomeIcons.user,
                                size: 20,
                                color: Colors.black54,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              labelText: "Seller Name",
                            ),
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            onSaved: (input) => name = input,
                          ),
                          kSmallSpacing,

                          //Company Name
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some data';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                FontAwesomeIcons.building,
                                size: 20,
                                color: Colors.black54,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              labelText: "Company name",
                            ),
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            onSaved: (input) => company = input,
                          ),
                          kSmallSpacing,

                          //Phone
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Mobile number';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                FontAwesomeIcons.mobileAlt,
                                color: Colors.black54,
                                size: 20,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              labelText: "Mobile",
                            ),
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            onSaved: (input) => mobile = input,
                          ),
                          kSmallSpacing,

                          //Address
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some data';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                FontAwesomeIcons.addressCard,
                                size: 20,
                                color: Colors.black54,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              labelText: "Address",
                            ),
                            keyboardType: TextInputType.streetAddress,
                            textInputAction: TextInputAction.done,
                            onSaved: (input) => location = input,
                          ),
                          kSmallSpacing,

                          //Button
                          RaisedButton(
                            onPressed: () async => onRegisterClick(),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            color: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 22),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  SizedBox buildBottomOverlay() {
    return SizedBox(
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Select profile picture",
            style: TextStyle(
                fontSize: 22,
                color: kPrimaryColor,
                fontWeight: FontWeight.w900),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton.icon(
                  onPressed: () async {
                    final pickedFile =
                        await _picker.getImage(source: ImageSource.camera);
                    setState(() {
                      _imageFile = pickedFile;
                    });
                    Navigator.pop(context);
                  },
                  color: kPrimaryColor,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  icon: const Icon(
                    FontAwesomeIcons.camera,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    "Camera",
                    style: TextStyle(color: Colors.white),
                  )),
              const SizedBox(width: 10),
              RaisedButton.icon(
                  onPressed: () async {
                    final pickedFile =
                        await _picker.getImage(source: ImageSource.gallery);
                    setState(() {
                      _imageFile = pickedFile;
                    });
                    Navigator.pop(context);
                  },
                  color: kPrimaryColor,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  icon: const Icon(
                    FontAwesomeIcons.images,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    "Gallery",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          )
        ],
      ),
    );
  }

  Future<void> onRegisterClick() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final String uid = FirebaseAuth.instance.currentUser.uid;
      final String fileName =
          _imageFile == null ? 'default' : p.basename(_imageFile.path);

      //Getting Shop Id
      int id;
      try {
        id = await APIHandler.getShopIdForNewUser();
      } catch (e) {
        Scaffold.of(context).showSnackBar(errorSnack(e.toString()));
        return;
      }

      //Uploading file
      try {
        String url = 'default';
        if (fileName != 'default') {
          final Reference firebaseStorageRef =
              FirebaseStorage.instance.ref().child('uploads/$uid/$fileName');
          final uploadTask =
              await firebaseStorageRef.putFile(File(_imageFile.path));
          url = await uploadTask.ref.getDownloadURL();
        }
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'shopId': id,
          'name': name,
          'shopName': company,
          'mobile': mobile,
          'location': location,
          'profileImg': url
        });

        await APIHandler.saveShopDetails(name);

        await SharedPrefs.saveStr('name', name);
        await SharedPrefs.saveStr('current_screen', SellerMainScreen.id);
        Navigator.popAndPushNamed(context, SellerMainScreen.id);
      } catch (e) {
        _key.currentState
            .showSnackBar(errorSnack('Unable to upload Profile image.'
                ' Make sure you have a stable network connection '
                'and try again'));
      }
    }
    setState(() {
      isLoading = false;
    });
  }
}
