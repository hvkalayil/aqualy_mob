import 'package:aqua_ly/Api/api_handler.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';

class SellerAllOrdersScreen extends StatefulWidget {
  static String id = 'AllOrder screen';
  @override
  _SellerAllOrdersScreenState createState() => _SellerAllOrdersScreenState();
}

class _SellerAllOrdersScreenState extends State<SellerAllOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Orders'),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
            future: APIHandler.getOrdersForShop(getActive: false),
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
    );
  }

  Container makeFish(Map<String, dynamic> data) {
    final bool isActive = data['isActive'] as bool;
    final String user = data['userName'] as String;
    final String image = data['image'] as String;
    final String name = data['name'] as String;
    final int price = data['price'] as int;
    final int discount = data['discount'] as int;
    final int finalPrice = price - (price ~/ discount);
    final String location = data['location'] as String;
    final String status = isActive ? 'Deliver' : 'Delivered';

    return Container(
      height: 120,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: isActive ? kPrimaryColor : Colors.green,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
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
                  '$status to $user at $location',
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
