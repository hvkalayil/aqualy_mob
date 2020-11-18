import 'package:aqua_ly/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _n = 0;
  void add() {
    setState(() {
      _n++;
    });
  }

  void minus() {
    setState(() {
      if (_n != 0) _n--;
    });
  }

  ///Don't use Scaffold here. These 4 pages have one scaffold
  ///mentioned in main_screen.dart
  ///Other screens which does not need the bottom bar can have Scaffold
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
            "MY CART",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Expanded(
            child: ListView(
              children: [
                makeFish(
                    image: 'fish1.png',
                    name: 'HALFMOON BETTA',
                    price: '200',
                    no: "3"),
                makeFish(
                    image: 'fish2.png',
                    name: 'GOLD FISH',
                    price: '50',
                    no: '1'),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Subtotal(3 items)", style: TextStyle(fontSize: 20)),
              const Text(
                "Rs  2860",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )
            ],
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: RaisedButton(
              onPressed: () {},
              color: kPrimaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Check Out",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Icon(
                    FontAwesomeIcons.forward,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container makeFish({String image, String name, String price, String no}) {
    return Container(
      height: 138,
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
            mainAxisAlignment: MainAxisAlignment.center,
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
            ],
          ),
          Column(
            children: [
              IconButton(
                  icon: Icon(FontAwesomeIcons.plus),
                  onPressed: () {
                    add();
                  }),
              Text(
                '$_n',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              IconButton(
                  icon: Icon(FontAwesomeIcons.minus),
                  onPressed: () {
                    minus();
                  })
            ],
          )
        ],
      ),
    );
  }
}
