import 'package:flutter/material.dart';

class fish_info extends StatelessWidget {
  static String id = 'fishinfo';
  const fish_info({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Text("Name"), Text("price")],
          ),
          Row(
            children: [
              Column(
                children: [
                  Text(
                    "Specifications",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("size"),
                  Text("color"),
                  Text("gender")
                ],
              ),
              Image(
                image: AssetImage("assets/graphics/gold.png"),
                width: 200,
                height: 200,
                fit: BoxFit.fill,
              )
            ],
          ),
          Column(children: [
            Text("features"),
            Text("feature1"),
            Text("feature2"),
            Text("feature3")
          ]),
          RaisedButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("buy now"), Icon(Icons.forward)],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
          )
        ],
      )),
    );
  }
}
