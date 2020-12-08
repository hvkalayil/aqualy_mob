import 'package:aqua_ly/Api/api_handler.dart';
import 'package:aqua_ly/constants.dart';
import 'package:aqua_ly/theme.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int> cartIds = [];
  int total = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          //Heading
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: const Center(
              child: Text(
                "MY CART",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: kPrimaryColor),
              ),
            ),
          ),

          //Cart
          FutureBuilder<List<Map<String, dynamic>>>(
              future: APIHandler.getOrdersForCustomer(getEverything: false),
              builder: (context, snapshot) {
                // 1 -> Error
                if (snapshot.hasError) {
                  return kError(snapshot.error.toString());
                }

                // 2 -> Success
                else if (snapshot.hasData) {
                  if (snapshot.data.isEmpty) {
                    return kError('No Pending Orders');
                  } else {
                    final List<Map<String, dynamic>> data = snapshot.data;
                    return Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          padding: const EdgeInsets.only(top: 20),
                          decoration: const BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          child: ListView(
                            children: data
                                .asMap()
                                .entries
                                .map((e) => makeFish(e.value))
                                .toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text("Total",
                                  style: TextStyle(
                                      fontSize: 20, color: kPrimaryColor)),
                              Text(
                                "₹  ${data.last['finalPrice']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: kPrimaryColor),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                          child: RaisedButton(
                            onPressed: () => checkOutCart(),
                            color: kPrimaryColor,
                            padding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text("Check Out",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                Icon(
                                  FontAwesomeIcons.forward,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }
                }

                // 3 -> Loading
                else {
                  return kLoading;
                }
              }),
        ],
      ),
    );
  }

  GestureDetector makeFish(Map<String, dynamic> data) {
    final int id = data['cart_id'] as int;
    if (!cartIds.contains(id)) cartIds.add(id);
    final String image = data['image'] as String;
    final String name = data['name'] as String;
    final int price = data['price'] as int;
    final int color = data['color'] as int;
    final int size = data['size'] as int;
    total += price;
    return GestureDetector(
      onTap: () => removeItemFromCart(id),
      child: Container(
        height: 138,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Image.network(
                image,
                errorBuilder: (context, widget, error) => Image.asset(kDefImg),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    name,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '₹$price',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: kListOfColors[color],
                      ),
                      const SizedBox(width: 10),
                      Text(
                        kListOfSizes[size],
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, color: Colors.white),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkOutCart() {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Checkout Cart'),
          content: const Text('Are you sure you want to order these items?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () async {
                for (final int id in cartIds) {
                  try {
                    await APIHandler.markAsOutForDelivery(id);
                  } catch (e) {
                    Scaffold.of(context).showSnackBar(errorSnack(e.toString()));
                    return;
                  }
                }
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
              child: const Text('Yes'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void removeItemFromCart(int id) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Remove Item'),
          content: const Text(
              'Are you sure you want to delete this item from cart?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () async {
                try {
                  await APIHandler.removeFromCart(id);
                } catch (e) {
                  Scaffold.of(context).showSnackBar(errorSnack(e.toString()));
                }
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
              child: const Text("Yes"),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }
}
