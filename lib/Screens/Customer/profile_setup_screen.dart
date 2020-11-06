import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  final ImagePicker _picker = ImagePicker();
  static const kSmallSpacing = SizedBox(height: 10);
  static const kBigSpacing = SizedBox(height: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: _imageFile == null
                                ? const AssetImage(
                                    'assets/graphics/male.png',
                                  )
                                : FileImage(File(_imageFile.path)),
                            fit: BoxFit.cover,
                          )),
                    )),

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
                        Icons.camera_alt,
                        color: kPrimaryColor,
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
                        prefixIcon: const Icon(Icons.add),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        labelText: "Name",
                      ),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
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
                        prefixIcon: const Icon(Icons.add),
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
                        prefixIcon: const Icon(Icons.add),
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
            "Select profile pic",
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
                    Icons.camera,
                    color: Colors.white,
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
                    Icons.image,
                    color: Colors.white,
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

  void onRegisterClick() {
    _formKey.currentState.validate();
  }
}
