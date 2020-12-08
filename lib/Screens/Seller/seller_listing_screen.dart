import 'package:aqua_ly/Api/api_handler.dart';
import 'package:aqua_ly/Screens/Seller/add_listing.dart';
import 'package:aqua_ly/Screens/Seller/edit_listing.dart';
import 'package:aqua_ly/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../theme.dart';

class SellerListingScreen extends StatefulWidget {
  @override
  _SellerListingScreenState createState() => _SellerListingScreenState();
}

class _SellerListingScreenState extends State<SellerListingScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Recently Added Heading
        Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Listings',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              FlatButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AddListingScreen.id),
                color: Colors.white,
                shape: const CircleBorder(),
                child: const Icon(
                  FontAwesomeIcons.plus,
                  color: kPrimaryColor,
                ),
              )
            ],
          ),
        ),

        //List
        FutureBuilder<List<Map<String, dynamic>>>(
            future: APIHandler.getListings(),
            builder: (context, snapshot) {
              //1 -> Error
              if (snapshot.hasError) {
                return kError(snapshot.error.toString());
              }

              // 2 -> Success
              else if (snapshot.hasData) {
                final List<Map<String, dynamic>> data = snapshot.data;
                if (data.isEmpty) {
                  return kError('No Listings Added');
                } else {
                  return Expanded(
                    child: ListView(
                      children: data
                          .asMap()
                          .entries
                          .map((e) => makeFish(e.value))
                          .toList(),
                    ),
                  );
                }
              }

              // 3 -> Loading
              else {
                return kLoading;
              }
            })
      ],
    );
  }

  bool isLove = false;

  GestureDetector makeFish(Map<String, dynamic> data) {
    final int id = data['id'] as int;
    final int pId = data['productId'] as int;
    final String type = data['productType'] as String;
    final String image = data['image'] as String;
    final String name = data['name'] as String;
    final int price = data['price'] as int;
    final int discount = data['discount'] as int;
    final int stock = data['stock'] as int;
    final String color = data['color'] as String;
    final String size = data['size'] as String;

    final int finalPrice = price - (price * discount) ~/ 100;
    final List<int> listOfColors = parseIntFromString(color);
    final List<int> listOfSizes = parseIntFromString(size);

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => EditListingScreen(
                    data: {
                      'id': id,
                      'productId': pId,
                      'image': image,
                      'productType': type,
                      'name': name,
                      'price': price,
                      'discount': discount,
                      'stock': stock,
                      'color': color,
                      'size': size,
                    },
                  ))),
      child: Container(
        height: 160,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.5),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 100,
              child: Image.network(
                image,
                errorBuilder: (context, widget, err) => Image.asset(kDefImg),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$name  ₹$finalPrice',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: listOfColors
                      .asMap()
                      .entries
                      .map((e) => createColors(e.value))
                      .toList(),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: listOfSizes
                      .asMap()
                      .entries
                      .map((e) => createSizes(e.value))
                      .toList(),
                ),
                Text(
                  '$stock stock left',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Padding createColors(int data) {
    final Color value = kListOfColors[data];
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: CircleAvatar(
        radius: 12,
        backgroundColor: value,
        child: const Icon(
          FontAwesomeIcons.check,
          color: Colors.white,
          size: 12,
        ),
      ),
    );
  }

  Padding createSizes(int data) {
    final String value = kListOfSizes[data];
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
          padding: const EdgeInsets.all(5.0),
          decoration: const BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Text(
            value,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white),
          )),
    );
  }
}
