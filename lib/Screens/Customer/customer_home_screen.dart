import 'package:aqua_ly/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  ///Don't use Scaffold here. These 4 pages have one scaffold
  ///mentioned in main_screen.dart
  ///Other screens which does not need the bottom bar can have Scaffold
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: const Icon(FontAwesomeIcons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              labelText: "Search for product",
            ),
          ),
          const Text(
            "DISCOVER",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            const Icon(FontAwesomeIcons.sort),
            RaisedButton(
                onPressed: () {},
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                color: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: const Text("Fishes",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15))),
            RaisedButton(
                onPressed: () {},
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                color: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: const Text("Fish Food",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15))),
            RaisedButton(
                onPressed: () {},
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                color: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: const Text("Accessories",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15)))
          ])
        ],
      ),
    );
  }
}
