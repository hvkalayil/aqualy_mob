import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../theme.dart';

class SellerProfileScreen extends StatefulWidget {
  @override
  _SellerProfileScreenState createState() => _SellerProfileScreenState();
}

class _SellerProfileScreenState extends State<SellerProfileScreen> {
  PickedFile _imageFile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  static const kSmallSpacing = SizedBox(height: 10);
  static const kBigSpacing = SizedBox(height: 20);
  String name, mobile, location;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          kBigSpacing,
          //Heading 1
          const Text(
            "Welcome",
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                color: kPrimaryColor),
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
                      labelText: "Seller Name",
                    ),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
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
                    textInputAction: TextInputAction.done,
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
                      "Update",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 22),
                    ),
                  ),

                  //Validate Button
                  FlatButton(
                      onPressed: () {},
                      child: const Text(
                        "Verify Email",
                        style: TextStyle(color: Colors.blue, fontSize: 15),
                      ))
                ],
              ),
            ),
          )
        ],
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
    // if (_formKey.currentState.validate())
  }
}