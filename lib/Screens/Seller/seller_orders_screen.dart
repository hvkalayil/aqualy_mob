import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                'Pending Orders',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              FlatButton(
                onPressed: () {},
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
          child: ListView(
            children: [
              makeFish(
                  image: 'fish1.png',
                  name: 'HALFMOON BETTA',
                  price: '200',
                  location: 'Puthuppally'),
              makeFish(
                  image: 'fish2.png',
                  name: 'GOLD FISH',
                  price: '50',
                  location: 'Palai'),
              makeFish(
                  image: 'fish1.png',
                  name: 'HALFMOON BETTA',
                  price: '200',
                  location: 'Kozhikode'),
            ],
          ),
        ),

        //Show All
        RaisedButton(
          color: kPrimaryColor,
          padding: const EdgeInsets.all(10),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          onPressed: () {},
          child: const Text(
            'Show All Orders',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 20)
      ],
    );
  }

  bool isLove = false;

  Container makeFish(
      {String image, String name, String price, String location}) {
    return Container(
      height: 100,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                image: DecorationImage(
                    image: AssetImage('assets/graphics/$image'))),
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
                'Rs $price',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                location,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              )
            ],
          )
        ],
      ),
    );
  }
}
