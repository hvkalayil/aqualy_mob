import 'package:flutter/material.dart';

class FishInfoScreen extends StatelessWidget {
  static String id = 'fishinfo';
  const FishInfoScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.blue,
              ),
              onPressed: () {})
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: const [Text("Name"), Text("price")],
          ),
          Row(
            children: [
              Column(
                children: const [
                  Text(
                    "Specifications",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("size"),
                  Text("color"),
                  Text("gender")
                ],
              ),
              const Image(
                image: AssetImage("assets/graphics/gold.png"),
                width: 200,
                height: 200,
                fit: BoxFit.fill,
              )
            ],
          ),
          Column(children: const [
            Text("features"),
            Text("feature1"),
            Text("feature2"),
            Text("feature3")
          ]),
          RaisedButton(
            onPressed: () {},
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [Text("buy now"), Icon(Icons.forward)],
            ),
          )
        ],
      )),
    );
  }
}
