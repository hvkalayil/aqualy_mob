import 'package:aqua_ly/Api/api_handler.dart';
import 'package:aqua_ly/constants.dart';
import 'package:aqua_ly/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditListingScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  static const String id = 'Edit Listing screen';

  const EditListingScreen({Key key, this.data}) : super(key: key);

  @override
  _EditListingScreenState createState() => _EditListingScreenState();
}

class _EditListingScreenState extends State<EditListingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  static const kSmallSpacing = SizedBox(height: 10);
  static const kBigSpacing = SizedBox(height: 20);

  bool showColorError = false;
  bool showSizeError = false;
  bool upload = false;
  String name, image, type, color, size, discount, stock;
  int price;

  @override
  void initState() {
    super.initState();
    image = widget.data['image'] as String;
    name = widget.data['name'] as String;
    price = widget.data['price'] as int;
    type = widget.data['productType'] as String;
    color = widget.data['color'] as String;
    size = widget.data['size'] as String;
    discount = widget.data['discount'].toString();
    stock = widget.data['stock'].toString();
    selectedColors = parseIntFromString(color);
    selectedSizes = parseIntFromString(size);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: SafeArea(
        child: upload
            ? showLoading()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      //Heading 1
                      kBigSpacing,
                      const Text(
                        "Edit Listing",
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
                                initialValue: stock,
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
                                initialValue: discount,
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
                                  "Edit Listing",
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
              ),
      ),
    );
  }

  Center showLoading() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Uploading files'),
            kSmallSpacing,
            CircularProgressIndicator()
          ],
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

      final String color = createString(selectedColors);
      final String size = createString(selectedSizes);
      try {
        await APIHandler.editListing(
            productId: widget.data['productId'] as int,
            listingId: widget.data['id'] as int,
            colors: color,
            sizes: size,
            discount: int.parse(discount),
            stock: int.parse(stock));
        setState(() {
          upload = false;
        });
        Navigator.pop(context);
      } catch (e) {
        _key.currentState.showSnackBar(errorSnack(e.toString()));
      }
    }
  }
}
