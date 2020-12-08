import 'package:aqua_ly/Api/api_handler.dart';
import 'package:aqua_ly/constants.dart';
import 'package:aqua_ly/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddListingScreen extends StatefulWidget {
  static String id = 'Add listing Screen';

  @override
  _AddListingScreenState createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  static const kSmallSpacing = SizedBox(height: 10);
  static const kBigSpacing = SizedBox(height: 20);
  bool upload = false;
  bool productSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(),
      body: upload
          //If registration is being done
          ? showLoading()
          : productSelected
              //Show registration form
              ? showForm()
              //Show list of available products
              : showProducts(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: productSelected ? Colors.redAccent : Colors.blue,
        onPressed: () {
          setState(() {
            productSelected = !productSelected;
          });
        },
        child: Icon(
            productSelected ? FontAwesomeIcons.times : FontAwesomeIcons.check),
      ),
    );
  }

  Center showLoading() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Adding new Listing'),
            kSmallSpacing,
            CircularProgressIndicator()
          ],
        ),
      );

  String discount, stock;
  bool showColorError = false;
  bool showSizeError = false;
  //Shows Form
  SingleChildScrollView showForm() => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<Map<String, dynamic>>(
              future: APIHandler.getProductById(chosenId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return kError(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  final Map<String, dynamic> data = snapshot.data;
                  final String image = data['image'] as String;
                  final String name = data['name'] as String;
                  final int price = data['price'] as int;
                  final String type = data['productType'] as String;
                  return Column(
                    children: [
                      //Heading 1
                      kBigSpacing,
                      const Text(
                        "Add Listing",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                            color: kPrimaryColor),
                      ),
                      kBigSpacing,

                      //Profile Image & Edit Button
                      CircleAvatar(
                        backgroundColor: kPrimaryColor,
                        radius: 80,
                        child: Container(
                          height: 140,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: Image.network(
                            image,
                            errorBuilder: (context, wid, err) =>
                                Image.asset(kDefImg),
                          ),
                        ),
                      ),
                      kBigSpacing,

                      //Name
                      TextFormField(
                        initialValue: name,
                        enabled: false,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            FontAwesomeIcons.tags,
                            size: 20,
                            color: Colors.black54,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          labelText: "Product Name",
                        ),
                      ),
                      kSmallSpacing,

                      //Price
                      TextFormField(
                        initialValue: price.toString(),
                        enabled: false,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            FontAwesomeIcons.donate,
                            color: Colors.black54,
                            size: 20,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          labelText: "Price",
                        ),
                      ),
                      kSmallSpacing,

                      //Type
                      TextFormField(
                        initialValue: type == 'F' ? 'Fish' : 'Accessory',
                        enabled: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          labelText: "Product Type",
                        ),
                      ),
                      kSmallSpacing,

                      //Form
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              //Color picker
                              Container(
                                decoration: BoxDecoration(
                                    color: kPrimaryColor.withOpacity(0.5),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 10),
                                          const Icon(
                                            FontAwesomeIcons.eyeDropper,
                                            color: Colors.black54,
                                          ),
                                          const SizedBox(width: 10),
                                          const Text(
                                            'Colors',
                                            style: TextStyle(fontSize: 24),
                                          ),
                                          const SizedBox(width: 10),
                                          if (showColorError)
                                            const Text(
                                              'Please select a color',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.redAccent),
                                            )
                                          else
                                            const SizedBox(),
                                        ],
                                      ),
                                    ),
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      children: kListOfColors
                                          .asMap()
                                          .entries
                                          .map((e) =>
                                              createColors(e.key, e.value))
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                              kBigSpacing,

                              //Size picker
                              Container(
                                decoration: BoxDecoration(
                                    color: kPrimaryColor.withOpacity(0.5),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 10),
                                          const Icon(
                                            FontAwesomeIcons.weight,
                                            color: Colors.black54,
                                          ),
                                          const SizedBox(width: 10),
                                          const Text(
                                            'Size',
                                            style: TextStyle(fontSize: 24),
                                          ),
                                          const SizedBox(width: 10),
                                          if (showSizeError)
                                            const Text(
                                              'Please select a size',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.redAccent),
                                            )
                                          else
                                            const SizedBox(),
                                        ],
                                      ),
                                    ),
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      children: kListOfSizes
                                          .asMap()
                                          .entries
                                          .map((e) =>
                                              createSizes(e.key, e.value))
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                              kBigSpacing,

                              //Stock
                              TextFormField(
                                // ignore: missing_return
                                validator: (input) {
                                  if (input.isEmpty) {
                                    return 'Add stock you have';
                                  }
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    FontAwesomeIcons.layerGroup,
                                    color: Colors.black54,
                                    size: 20,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  labelText: "Stock",
                                ),
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                onSaved: (input) => stock = input,
                              ),
                              kSmallSpacing,

                              //Discount
                              TextFormField(
                                // ignore: missing_return
                                validator: (input) {
                                  if (input.isEmpty) {
                                    return 'Add a discount or enter 0';
                                  }
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    FontAwesomeIcons.percentage,
                                    color: Colors.black54,
                                    size: 20,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  labelText: "Discount",
                                ),
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                onSaved: (input) => discount = input,
                              ),
                              kSmallSpacing,

                              //Button
                              RaisedButton(
                                onPressed: () async => onAddListingClick(),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                color: kPrimaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Text(
                                  "Add Listing",
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
                  );
                } else {
                  return kLoading;
                }
              }),
        ),
      );

  List<int> selectedColors = [];
  Padding createColors(int key, Color value) {
    final bool selected = selectedColors.contains(key);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
          onTap: () {
            if (selected) {
              setState(() {
                selectedColors.remove(key);
              });
            } else {
              setState(() {
                selectedColors.add(key);
              });
            }
          },
          child: CircleAvatar(
            backgroundColor: value,
            child: selected
                ? const Icon(
                    FontAwesomeIcons.check,
                    color: Colors.white,
                    size: 18,
                  )
                : const SizedBox(),
          )),
    );
  }

  List<int> selectedSizes = [];
  Padding createSizes(int key, String value) {
    final bool selected = selectedSizes.contains(key);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
          onTap: () {
            if (selected) {
              setState(() {
                selectedSizes.remove(key);
              });
            } else {
              setState(() {
                selectedSizes.add(key);
              });
            }
          },
          child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: selected ? kPrimaryColor : Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: Text(
                value,
                style: TextStyle(
                    fontWeight: selected ? FontWeight.w900 : FontWeight.w500,
                    color: selected ? Colors.white : kPrimaryColor),
              ))),
    );
  }

  //Shows Products
  int chosenId = -1;
  FutureBuilder<List<Map<String, dynamic>>> showProducts() =>
      FutureBuilder<List<Map<String, dynamic>>>(
          future: APIHandler.getAllProductsForShopUser(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return kError(snapshot.error.toString());
            } else if (snapshot.hasData) {
              final List<Map<String, dynamic>> data = snapshot.data;
              if (data.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "No more products to add listing",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                );
              } else {
                return AnimationLimiter(
                  child: GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      crossAxisCount: 2,
                    ),
                    children: data
                        .asMap()
                        .entries
                        .map((e) => makeFish(data: e.value, index: e.key))
                        .toList(),
                  ),
                );
              }
            } else {
              return kLoading;
            }
          });

  AnimationConfiguration makeFish({Map<String, dynamic> data, int index}) {
    final int productId = data['id'] as int;
    final String name = data['name'] as String;
    final int price = data['price'] as int;
    final String image = data['image'] as String ?? '';
    return AnimationConfiguration.staggeredGrid(
      position: index,
      duration: const Duration(seconds: 1),
      columnCount: 2,
      child: FlipAnimation(
        child: GestureDetector(
          onTap: () {
            setState(() {
              chosenId = productId;
            });
          },
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: productId == chosenId
                              ? kPrimaryColor.withOpacity(0.25)
                              : Colors.transparent,
                          blurRadius: 4,
                          spreadRadius: 4)
                    ],
                    color: kPrimaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.17,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Image.network(
                        image,
                        fit: BoxFit.scaleDown,
                        loadingBuilder: (context, widget, event) =>
                            const CircularProgressIndicator(),
                        errorBuilder: (context, widget, event) =>
                            Image.asset(kDefImg),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900),
                        ),
                        Text(
                          ' ₹$price',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              if (productId == chosenId)
                const Positioned(
                  top: 20,
                  right: 20,
                  child: Icon(
                    FontAwesomeIcons.checkCircle,
                    size: 30,
                    color: Colors.white,
                  ),
                )
              else
                const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onAddListingClick() async {
    if (_formKey.currentState.validate()) {
      if (selectedColors.isEmpty) {
        setState(() {
          showColorError = true;
        });
        return;
      }
      setState(() {
        showColorError = false;
      });
      if (selectedSizes.isEmpty) {
        setState(() {
          showSizeError = true;
        });
        return;
      }
      setState(() {
        showSizeError = false;
        upload = true;
      });
      _formKey.currentState.save();

      //Validation done adding data Setting up data
      final String colors = createString(selectedColors);
      final String sizes = createString(selectedSizes);
      try {
        await APIHandler.addListing(
            colors: colors,
            stock: stock,
            discount: discount,
            sizes: sizes,
            productId: chosenId);
        Navigator.of(context).pop();
      } catch (e) {
        _key.currentState.showSnackBar(errorSnack(e.toString()));
      }
      setState(() {
        upload = false;
      });
    }
  }
}
