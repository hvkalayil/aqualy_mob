import 'package:aqua_ly/Api/api_handler.dart';
import 'package:aqua_ly/Screens/Seller/add_product.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../theme.dart';

class SellerProductScreen extends StatefulWidget {
  @override
  _SellerProductScreenState createState() => _SellerProductScreenState();
}

class _SellerProductScreenState extends State<SellerProductScreen> {
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
                'Your Products',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              FlatButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AddProductScreen.id),
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
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
              future: APIHandler.productsAddedBy(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return kError(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  final List<Map<String, dynamic>> data = snapshot.data;
                  if (data.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [Text("You have'nt added any products")],
                    );
                  } else {
                    return ListView(
                      children: data
                          .asMap()
                          .entries
                          .map((e) => makeFish(data: e.value))
                          .toList(),
                    );
                  }
                } else {
                  return kLoading;
                }
              }),
        )
      ],
    );
  }

  bool isLove = false;

  Container makeFish({Map<String, dynamic> data}) {
    final String name = data['name'] as String;
    final int price = data['price'] as int;
    final bool status = data['verified'] as bool;
    final String image = data['image'] as String ?? '';
    return Container(
      height: 100,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: status ? Colors.green : kPrimaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Image.network(
              image,
              loadingBuilder: (context, widget, event) =>
                  const CircularProgressIndicator(),
              errorBuilder: (context, widget, event) => Image.asset(kDefImg),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              Text(
                '₹ $price',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              Row(
                children: [
                  Icon(
                    status
                        ? FontAwesomeIcons.userCheck
                        : FontAwesomeIcons.microscope,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    status ? 'Verified' : 'Verifying',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
