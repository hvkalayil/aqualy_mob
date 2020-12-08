import 'package:aqua_ly/Api/api_handler.dart';
import 'package:aqua_ly/Screens/Seller/add_listing.dart';
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
                  FutureBuilder<String>(
                      future: APIHandler.getShopRevenue(),
                      builder: (context, snapshot) {
                        ///1 -> Error
                        if (snapshot.hasError) {
                          return Text('Oops..${snapshot.error.toString()}');
                        }

                        ///2 -> Success
                        else if (snapshot.hasData) {
                          final String rev = snapshot.data;
                          return Text(
                            '₹ $rev',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 38,
                                letterSpacing: 2),
                          );
                        }

                        ///3 -> Loading
                        else {
                          return kLoading;
                        }
                      }),
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
                            child: SizedBox(
                              height: 80,
                              width: 80,
                              child: Center(
                                child: FutureBuilder<String>(
                                    future: APIHandler.getNumOrders(),
                                    builder: (context, snapshot) {
                                      // 1 -> Error
                                      if (snapshot.hasError) {
                                        return kError(
                                            snapshot.error.toString());
                                      }

                                      // 2 -> Success
                                      else if (snapshot.hasData) {
                                        return Text(
                                          snapshot.data,
                                          style: const TextStyle(
                                              fontSize: 24,
                                              color: Colors.white),
                                        );
                                      }

                                      // 3 -> Loading
                                      else {
                                        return kLoading;
                                      }
                                    }),
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
                            child: SizedBox(
                              height: 80,
                              width: 80,
                              child: Center(
                                child: FutureBuilder<double>(
                                    future: APIHandler.getShopRating(),
                                    builder: (context, snapshot) {
                                      // 1 -> Error
                                      if (snapshot.hasError) {
                                        return kError(
                                            snapshot.error.toString());
                                      }

                                      // 2 -> Success
                                      else if (snapshot.hasData) {
                                        final String msg = snapshot.data == 0
                                            ? '⛔'
                                            : snapshot.data.toString();
                                        return Text(
                                          msg,
                                          style: const TextStyle(
                                              fontSize: 24,
                                              color: Colors.white),
                                        );
                                      }

                                      // 3 -> Loading
                                      else {
                                        return kLoading;
                                      }
                                    }),
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
                          onPressed: () => Navigator.of(context)
                              .pushNamed(AddListingScreen.id),
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
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: APIHandler.getListings(),
                        builder: (context, snapshot) {
                          //1 -> Error
                          if (snapshot.hasError) {
                            return kError(snapshot.error.toString());

                            // 2 -> Success
                          } else if (snapshot.hasData) {
                            if (snapshot.data.isEmpty) {
                              return kError("You have'nt added any listings",
                                  style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white));
                            } else {
                              final List<Map<String, dynamic>> data =
                                  snapshot.data;
                              return ListView(
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

  Container makeFish(Map<String, dynamic> data) {
    final String image = data['image'] as String;
    final String name = data['name'] as String;
    final int price = data['price'] as int;
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
            child: Image.network(
              image,
              errorBuilder: (context, widget, err) => Image.asset(kDefImg),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: SizedBox(
              width: 150,
              height: 100,
              child: Text(
                name,
                softWrap: true,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          ),
          Positioned(
              bottom: 10,
              right: 10,
              child: Text('₹ $price',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white))),
        ],
      ),
    );
  }
}
