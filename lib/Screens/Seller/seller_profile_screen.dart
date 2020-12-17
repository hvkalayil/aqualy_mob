import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

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
  String name, mobile, location, company, image;
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return isUploading
        ? kLoading
        : FutureBuilder<Map<String, dynamic>>(
            future: getProfile(),
            builder: (context, snapshot) {
              ///1 -> Error
              if (snapshot.hasError) {
                return const Center(
                  child:
                      Text('Oops..There has been some error. Try Again Later'),
                );
              }

              ///2 -> Success
              else if (snapshot.hasData) {
                image = snapshot.data['profileImg'] as String;
                name = snapshot.data['name'] as String;
                company = snapshot.data['shopName'] as String;
                mobile = snapshot.data['mobile'] as String;
                location = snapshot.data['location'] as String;

                return Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        kBigSpacing,
                        //Profile Image & Edit Button
                        Stack(
                          children: [
                            //Profile Image
                            CircleAvatar(
                              backgroundColor: kPrimaryColor,
                              radius: 80,
                              child: ClipOval(
                                child: Container(
                                    height: 140,
                                    width: 140,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: _imageFile == null
                                        ? image == 'default'
                                            ? Image.asset(
                                                kDefProfile,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
                                                image,
                                                fit: BoxFit.fitWidth,
                                                errorBuilder:
                                                    (context, wid, s) =>
                                                        Image.asset(
                                                  kDefProfile,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                        : Image.file(File(_imageFile.path))),
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
                                        builder: (builder) =>
                                            buildBottomOverlay());
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
                                  initialValue: name,
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
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    labelText: "Seller Name",
                                  ),
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.next,
                                  onSaved: (input) => name = input,
                                ),
                                kSmallSpacing,

                                //Company Name
                                TextFormField(
                                  initialValue: company,
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
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    labelText: "Company name",
                                  ),
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.done,
                                  onSaved: (input) => company = input,
                                ),
                                kSmallSpacing,

                                //Phone
                                TextFormField(
                                  initialValue: mobile,
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
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    labelText: "Mobile",
                                  ),
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.next,
                                  onSaved: (input) => mobile = input,
                                ),
                                kSmallSpacing,

                                //Address
                                TextFormField(
                                  initialValue: location,
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
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    labelText: "Address",
                                  ),
                                  keyboardType: TextInputType.streetAddress,
                                  textInputAction: TextInputAction.done,
                                  onSaved: (input) => location = input,
                                ),
                                kSmallSpacing,

                                //Button
                                RaisedButton(
                                  onPressed: () => onUpdateClick(),
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
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 15),
                                    ))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }

              ///3 -> Loading
              else {
                return kLoading;
              }
            });
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

  Future<void> onUpdateClick() async {
    setState(() {
      isUploading = true;
    });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        final String uid = FirebaseAuth.instance.currentUser.uid;
        if (_imageFile != null) {
          final String fileName = p.basename(_imageFile.path);
          final Reference firebaseStorageRef =
              FirebaseStorage.instance.ref().child('uploads/$uid/$fileName');
          final uploadTask =
              await firebaseStorageRef.putFile(File(_imageFile.path));
          // ignore: parameter_assignments
          image = await uploadTask.ref.getDownloadURL();
        }

        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'name': name,
          'shopName': company,
          'mobile': mobile,
          'location': location,
          'profileImg': image
        });
      } catch (e) {
        Scaffold.of(context).showSnackBar(errorSnack(e.toString()));
      }
    }
    setState(() {
      isUploading = false;
    });
  }

  Future<Map<String, dynamic>> getProfile() async {
    final String uid = FirebaseAuth.instance.currentUser.uid;
    final s =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return s.data();
  }
}
