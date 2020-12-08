import 'package:aqua_ly/Api/api_handler.dart';
import 'package:aqua_ly/Screens/Customer/customer_rating_screen.dart';
import 'package:aqua_ly/constants.dart';
import 'package:aqua_ly/theme.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
                "ALL ORDERS",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: kPrimaryColor),
              ),
            ),
          ),

          //Cart
          FutureBuilder<List<Map<String, dynamic>>>(
              future: APIHandler.getOrdersForCustomer(getEverything: true),
              builder: (context, snapshot) {
                // 1 -> Error
                if (snapshot.hasError) {
                  return kError(snapshot.error.toString());
                }

                // 2 -> Success
                else if (snapshot.hasData) {
                  if (snapshot.data.isEmpty) {
                    return kError('No Orders');
                  } else {
                    final List<Map<String, dynamic>> data = snapshot.data;
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
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

  Container makeFish(Map<String, dynamic> data) {
    final String image = data['image'] as String;
    final String name = data['name'] as String;
    final int price = data['price'] as int;
    final int color = data['color'] as int;
    final int size = data['size'] as int;
    final String status = data['status'] as String;
    return Container(
      height: 180,
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
                ),
                Text(
                  status,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w900),
                ),
                if (status == kDelivered)
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => RatingScreen(
                                data: data,
                              )));
                    },
                    color: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Text('Review'),
                  )
                else
                  const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
