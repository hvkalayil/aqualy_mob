import 'package:aqua_ly/Api/api_handler.dart';
import 'package:aqua_ly/Screens/Seller/seller_all_order_screen.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';

class SellerOrdersScreen extends StatefulWidget {
  @override
  _SellerOrdersScreenState createState() => _SellerOrdersScreenState();
}

class _SellerOrdersScreenState extends State<SellerOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Recently Added Heading
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20))),
          child: const Text(
            'Pending Orders',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),

        //List
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
              future: APIHandler.getOrdersForShop(getActive: true),
              builder: (context, snapshot) {
                // 1 -> Error
                if (snapshot.hasError) {
                  return kError(snapshot.error.toString());
                }

                // 2 -> Success
                else if (snapshot.hasData) {
                  if (snapshot.data.isEmpty) {
                    return kError('No pending orders');
                  } else {
                    final List<Map<String, dynamic>> data = snapshot.data;
                    return ListView(
                      children: data
                          .asMap()
                          .entries
                          .map((e) => makeFish(e.value))
                          .toList(),
                    );
                  }
                }

                // 3 -> Loading
                else {
                  return kLoading;
                }
              }),
        ),

        //Show All
        RaisedButton(
          color: kPrimaryColor,
          padding: const EdgeInsets.all(10),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          onPressed: () =>
              Navigator.pushNamed(context, SellerAllOrdersScreen.id),
          child: const Text(
            'Show All Orders',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 20)
      ],
    );
  }

  GestureDetector makeFish(Map<String, dynamic> data) {
    final int cartId = data['cartId'] as int;
    final int userId = data['userId'] as int;
    final int listingId = data['listingId'] as int;
    final String user = data['userName'] as String;
    final String image = data['image'] as String;
    final String name = data['name'] as String;
    final int price = data['price'] as int;
    final int discount = data['discount'] as int;
    final int finalPrice = price - (price ~/ discount);
    final String location = data['location'] as String;

    return GestureDetector(
      onTap: () async {
        await showDialog<void>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Confirm Delivery'),
              content: const Text('Mark this product as delivered?'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    try {
                      APIHandler.markDelivered(
                          cart: cartId, user: userId, listing: listingId);
                    } catch (e) {
                      Scaffold.of(context)
                          .showSnackBar(errorSnack(e.toString()));
                    }
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Yes'),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('No'),
                ),
              ],
            );
          },
        );
        setState(() {});
      },
      child: Container(
        height: 120,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Image.network(
                image,
                errorBuilder: (context, widget, err) => Image.asset(kDefImg),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '$name ₹$finalPrice',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    'Deliver to $user at $location',
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
