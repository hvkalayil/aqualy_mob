import 'dart:io';
import 'package:aqua_ly/Screens/Customer/main_screen.dart';
import 'package:aqua_ly/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import '../../theme.dart';

class CustomerProfileSetupScreen extends StatefulWidget {
  static String id = 'Customer';

  @override
  _CustomerProfileSetupScreenState createState() =>
      _CustomerProfileSetupScreenState();
}

class _CustomerProfileSetupScreenState
    extends State<CustomerProfileSetupScreen> {
  PickedFile _imageFile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final ImagePicker _picker = ImagePicker();
  static const kSmallSpacing = SizedBox(height: 10);
  static const kBigSpacing = SizedBox(height: 20);

  String name, mobile, location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
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
              "Setup profile to continue",
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
                              image: AssetImage('assets/graphics/male.png'),
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
                        labelText: "Name",
                      ),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      onSaved: (input) => name = input,
                    ),
                    kSmallSpacing,

                    //Mobile
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
                      onPressed: () => onRegisterClick(),
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
                    )
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
                      borderRadius: BorderRadius.all(Radius.circular(20))),
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
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final String uid = FirebaseAuth.instance.currentUser.uid;
      final String fileName =
          _imageFile == null ? 'default' : p.basename(_imageFile.path);

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

        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'name': name,
          'mobile': mobile,
          'location': location,
          'profileImg': url
        });

        await SharedPrefs.saveStr('name', name);
        await SharedPrefs.saveStr('current_screen', MainScreen.id);
        Navigator.popAndPushNamed(context, MainScreen.id);
      } catch (e) {
        // ignore: avoid_print
        print(e.toString());
        _key.currentState.showSnackBar(const SnackBar(
            content: Text('Unable to upload Profile image.'
                ' Make sure you have a stable network connection '
                'and try again')));
      }
    }
  }
}
