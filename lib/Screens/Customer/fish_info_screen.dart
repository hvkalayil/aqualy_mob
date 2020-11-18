import 'package:aqua_ly/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FishInfoScreen extends StatelessWidget {
  static String id = 'Fish Info Screen';
  const FishInfoScreen({Key key}) : super(key: key);

  static const EdgeInsets kSmallPadding = EdgeInsets.all(10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Heading
              const SizedBox(height: 20),
              Container(
                padding: kSmallPadding,
                decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Halfmoon Betta",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                    ),
                    Text("₹200",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white))
                  ],
                ),
              ),
              const SizedBox(height: 20),

              //Product
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  "Specifications",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                            createSpecs(
                                ico: FontAwesomeIcons.balanceScale,
                                spec: 'Size',
                                val: '50g'),
                            createSpecs(
                                ico: FontAwesomeIcons.tint,
                                spec: 'Color',
                                val: 'Red'),
                            createSpecs(
                                ico: FontAwesomeIcons.transgender,
                                spec: 'Gender',
                                val: 'Male')
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        decoration: const BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20))),
                        child: const Image(
                          image: AssetImage("assets/graphics/fish1.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              //Reviews
              Column(
                children: const [
                  Text(
                    "Reviews",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "Review 1",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Review 2",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              //Add to cart
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RaisedButton(
                  onPressed: () {},
                  color: kPrimaryColor,
                  padding: const EdgeInsets.all(10),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(),
                      Text(
                        "Add to cart",
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        FontAwesomeIcons.cartPlus,
                        size: 24,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container createSpecs({IconData ico, String spec, String val}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), bottomLeft: Radius.circular(20))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(
              ico,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              Text(
                val,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
              Text(
                spec,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          )
        ],
      ),
    );
  }
}
