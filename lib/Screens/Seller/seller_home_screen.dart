import 'package:aqua_ly/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SellerHomeScreen extends StatefulWidget {
  @override
  _SellerHomeScreenState createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            //Revenue
            Container(
              width: MediaQuery.of(context).size.width,
              height: 225,
              margin: const EdgeInsets.only(right: 40, bottom: 20, top: 40),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(40))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Revenue',
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                  const Text(
                    'Rs 15,000',
                    style: TextStyle(
                        color: Colors.white, fontSize: 38, letterSpacing: 2),
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.75),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: const SizedBox(
                              height: 80,
                              width: 80,
                              child: Center(
                                child: Text(
                                  '10',
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            'New Orders',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.75),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: const SizedBox(
                              height: 80,
                              width: 80,
                              child: Center(
                                child: Text(
                                  '4.8',
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            'Rating',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),

            //Recent
            Container(
              margin: const EdgeInsets.only(left: 40),
              decoration: const BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(40))),
              child: Column(
                children: [
                  //Recently Added Heading
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recently Added',
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        makeFish(
                            image: 'fish1.png',
                            name: 'HALFMOON BETTA',
                            price: '200'),
                        makeFish(
                            image: 'fish2.png',
                            name: 'GOLD FISH',
                            price: '200'),
                        makeFish(
                            image: 'fish1.png',
                            name: 'HALFMOON BETTA',
                            price: '200'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isLove = false;

  Container makeFish({String image, String name, String price}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      width: 200,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Stack(
        children: [
          Container(
            transform: Matrix4.translationValues(40, -20, 0),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/graphics/$image'))),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            child: SizedBox(
              width: 150,
              height: 100,
              child: Text(
                name,
                softWrap: true,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Positioned(
              bottom: 15,
              left: 10,
              child: Text(price,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w900))),
          Positioned(
            right: 0,
            bottom: 10,
            child: RaisedButton(
              padding: const EdgeInsets.all(8),
              shape: const CircleBorder(),
              onPressed: () {
                setState(() {
                  isLove = !isLove;
                });
              },
              child: Icon(
                isLove ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                color: Colors.redAccent,
              ),
            ),
          )
        ],
      ),
    );
  }
}
