import 'package:aqua_ly/Screens/Customer/fish_info_screen.dart';
import 'package:aqua_ly/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ///Don't use Scaffold here. These 4 pages have one scaffold
  ///mentioned in main_screen.dart
  ///Other screens which does not need the bottom bar can have Scaffold

  String current = 'Fishes';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Search box
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: TextFormField(
              decoration: InputDecoration(
                prefixIcon: const Icon(FontAwesomeIcons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                labelText: "Search for product",
              ),
              textInputAction: TextInputAction.search,
            ),
          ),

          //BODY
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "DISCOVER",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 32),
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: ListView(
                  padding: const EdgeInsets.all(10),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    makeFish(
                        image: 'fish1.png',
                        name: 'HALFMOON BETTA',
                        price: '₹200'),
                    makeFish(image: 'fish2.png', name: 'GOLDFISH', price: '₹50')
                  ],
                ),
              ),

              //Products Filter
              Row(
                children: [
                  const SizedBox(width: 10),
                  const Icon(FontAwesomeIcons.slidersH),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 60,
                    height: 40,
                    child: Row(
                      children: [
                        makeSortButtons('Fishes'),
                        makeSortButtons('Accessories'),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),

          const SizedBox()
        ],
      ),
    );
  }

  Expanded makeSortButtons(String name) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: RaisedButton(
            onPressed: () {
              setState(() {
                current = name;
              });
            },
            color: current == name ? kPrimaryColor : Colors.blueGrey,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Text(name,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15))),
      ),
    );
  }

  bool isLove = false;
  GestureDetector makeFish({String image, String name, String price}) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, FishInfoScreen.id),
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
        width: 250,
        decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.15),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Stack(
          children: [
            Container(
              transform: Matrix4.translationValues(0, -50, 0),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/graphics/$image'))),
            ),
            Positioned(
              bottom: 20,
              left: 10,
              child: SizedBox(
                width: 200,
                height: 100,
                child: Text(
                  name,
                  softWrap: true,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Positioned(
                bottom: 15,
                left: 10,
                child: Text(price,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w900))),
          ],
        ),
      ),
    );
  }
}
