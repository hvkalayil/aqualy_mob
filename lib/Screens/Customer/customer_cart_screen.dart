import 'package:aqua_ly/theme.dart';
import 'package:flutter/cupertino.dart';
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
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
          ),

          //Total & button
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text("Total",
                        style: TextStyle(fontSize: 20, color: kPrimaryColor)),
                    Text(
                      "₹  250",
                      style: TextStyle(
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
                  onPressed: () {},
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
                  '₹ $price',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.plus,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    add();
                  }),
              Text(
                '$_n',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.minus,
                    color: Colors.white,
                  ),
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
