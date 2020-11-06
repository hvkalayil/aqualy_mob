import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomerProfileSetupScreen extends StatefulWidget {
  static String id = 'Customer';

  @override
  _CustomerProfileSetupScreenState createState() =>
      _CustomerProfileSetupScreenState();
}

class _CustomerProfileSetupScreenState
    extends State<CustomerProfileSetupScreen> {
  PickedFile _imageFile;

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(
            children: [
              const Text(
                "Welcome",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text("setup profile to continue"),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 80,
                      child: _imageFile == null
                          ? Image.asset(
                              'assets/graphics/gold.png') //Replace with default
                          : Image.file(
                              File(_imageFile.path),
                            ),
                    ),
                    InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (builder) {
                                return Container(
                                  height: 100,
                                  child: Column(
                                    children: [
                                      const Text("Select profile pic"),
                                      Row(
                                        children: [
                                          FlatButton.icon(
                                              onPressed: () async {
                                                final pickedFile =
                                                    await _picker.getImage(
                                                        source:
                                                            ImageSource.camera);
                                                setState(() {
                                                  _imageFile = pickedFile;
                                                });
                                              },
                                              icon: const Icon(Icons.camera),
                                              label: const Text("camera")),
                                          FlatButton.icon(
                                              onPressed: () async {
                                                final pickedFile =
                                                    await _picker.getImage(
                                                        source: ImageSource
                                                            .gallery);
                                                setState(() {
                                                  _imageFile = pickedFile;
                                                });
                                              },
                                              icon: const Icon(Icons.image),
                                              label: const Text("Gallery"))
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Icon(Icons.camera_alt))
                  ],
                ),
              )
            ],
          ),
          Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(10),
              child: Form(
                  child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'please enter name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      labelText: "Name",
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'please enter Mobile number';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      labelText: "Mobile",
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'please enter some data';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      labelText: "Address",
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {},
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      "Save",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )))
        ]));
  }
}
