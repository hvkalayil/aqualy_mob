import 'package:aqua_ly/Api/api_handler.dart';
import 'package:aqua_ly/Screens/Customer/fish_info_screen.dart';
import 'package:aqua_ly/constants.dart';
import 'package:aqua_ly/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String current = 'Fishes';
  bool showSearch = false;
  String search = '';
  List<Map<String, dynamic>> data = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            //Search box
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: TextFormField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(FontAwesomeIcons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                  labelText: "Search for product",
                ),
                textInputAction: TextInputAction.search,
                onTap: () {
                  setState(() {
                    showSearch = true;
                  });
                },
                onFieldSubmitted: (input) async {
                  setState(() {
                    data = searchLoading;
                  });
                  final List<Map<String, dynamic>> temp =
                      await APIHandler.searchProduct(input);
                  setState(() {
                    data = temp;
                  });
                },
              ),
            ),

            //BODY
            if (showSearch) showSearchResults() else showHome()
          ],
        ),
      ),
    );
  }

  ///----------------------------------------///
  ///               SEARCH RESULTS           ///
  ///----------------------------------------///
  Widget showSearchResults() {
    if (data == searchLoading) {
      return kLoading;
    } else {
      if (data.isEmpty) {
        return kError('Search  for a fish');
      } else {
        return SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: AnimationLimiter(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  crossAxisCount: 2,
                ),
                children: data
                    .asMap()
                    .entries
                    .map((e) => makeSearchFish(data: e.value, index: e.key))
                    .toList(),
              ),
            ));
      }
    }
  }

  AnimationConfiguration makeSearchFish(
      {Map<String, dynamic> data, int index}) {
    final int id = data['product_id'] as int;
    final String name = data['name'] as String;
    final int price = data['price'] as int;
    final String image = data['image'] as String ?? '';
    return AnimationConfiguration.staggeredGrid(
      position: index,
      duration: const Duration(seconds: 1),
      columnCount: 2,
      child: FlipAnimation(
        child: GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => FishInfoScreen(
                        data: {
                          'id': id,
                          'image': image,
                          'name': name,
                          'price': price
                        },
                      ))),
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.17,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Image.network(
                        image,
                        fit: BoxFit.scaleDown,
                        loadingBuilder: (context, widget, event) =>
                            const CircularProgressIndicator(),
                        errorBuilder: (context, widget, event) =>
                            Image.asset(kDefImg),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900),
                        ),
                        Text(
                          ' ₹$price',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///----------------------------------------///
  ///               HOME SCREEN              ///
  ///----------------------------------------///
  Padding showHome() => Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
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
              child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: APIHandler.getAllProducts(status: current),
                  builder: (context, snapshot) {
                    //1 -> Error
                    if (snapshot.hasError) {
                      return kError(snapshot.error.toString());
                    }

                    // 2-> Success
                    else if (snapshot.hasData) {
                      final List<Map<String, dynamic>> data = snapshot.data;
                      if (data.isEmpty) {
                        return kError(
                            'No Products in this category...Come back later');
                      } else {
                        return ListView(
                          padding: const EdgeInsets.all(10),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: data
                              .asMap()
                              .entries
                              .map((e) => makeFish(e.value))
                              .toList(),
                        );
                      }
                    }

                    // 3 -> Loading
                    else {
                      return kLoading;
                    }
                  }),
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
      );

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
  GestureDetector makeFish(Map<String, dynamic> data) {
    final int id = data['id'] as int;
    final String image = data['image'] as String;
    final String name = data['name'] as String;
    final int price = data['price'] as int;
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => FishInfoScreen(
                    data: {
                      'id': id,
                      'image': image,
                      'name': name,
                      'price': price
                    },
                  ))),
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
              child: Image.network(
                image,
                errorBuilder: (context, widget, error) => Image.asset(kDefImg),
              ),
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
                child: Text('₹$price',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w900))),
          ],
        ),
      ),
    );
  }
}
