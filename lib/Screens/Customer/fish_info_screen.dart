import 'package:aqua_ly/Api/api_handler.dart';
import 'package:aqua_ly/constants.dart';
import 'package:aqua_ly/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class FishInfoScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const FishInfoScreen({Key key, this.data}) : super(key: key);

  static const EdgeInsets kSmallPadding = EdgeInsets.all(10);

  @override
  _FishInfoScreenState createState() => _FishInfoScreenState();
}

class _FishInfoScreenState extends State<FishInfoScreen> {
  List<int> discounts = [];
  List<int> shopIds = [];
  List<int> listingIds = [];
  List<List<int>> sizes = [];
  List<List<int>> colors = [];
  int index = 0;
  int finalPrice = 0;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool adding = false;
  bool showAdding = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        appBar: AppBar(),
        body: SafeArea(
          child: FutureBuilder<Map<String, dynamic>>(
              future: APIHandler.getFishInfo(widget.data['id'] as int),
              builder: (context, snapshot) {
                // 1 -> Error
                if (snapshot.hasError) {
                  return kError(snapshot.error.toString());
                }

                // 2 -> Success
                else if (snapshot.hasData) {
                  final listData = snapshot.data;
                  discounts = listData['discounts'] as List<int>;
                  sizes = listData['sizes'] as List<List<int>>;
                  colors = listData['colors'] as List<List<int>>;
                  shopIds = listData['shop_id'] as List<int>;
                  listingIds = listData['id'] as List<int>;
                  finalPrice = (widget.data['price'] as int) -
                      ((widget.data['price'] as int) * discounts[index]) ~/ 100;
                  if (adding) {
                    return kLoading;
                  } else {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Heading
                          const SizedBox(height: 20),
                          Center(
                            child: Container(
                              width: 300,
                              padding: FishInfoScreen.kSmallPadding,
                              decoration: const BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Column(
                                children: [
                                  Text(
                                    widget.data['name'] as String,
                                    style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white),
                                  ),
                                  Text("₹$finalPrice",
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white))
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          //Product
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor.withOpacity(0.5),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Specifications",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                        Column(
                                          children: [
                                            createSizes(sizes[index]),
                                            createColors(colors[index]),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      decoration: const BoxDecoration(
                                        color: kPrimaryColor,
                                      ),
                                      child: Image.network(
                                        widget.data['image'] as String,
                                        errorBuilder:
                                            (context, widget, error) =>
                                                Image.asset(kDefImg),
                                      )),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          //Variants
                          showVariants(),

                          //Reviews
                          showReviews()
                        ],
                      ),
                    );
                  }
                }

                // 3 -> Loading
                else {
                  return kLoading;
                }
              }),
        ),
        floatingActionButton: showAdding
            ? SizedBox(
                width: MediaQuery.of(context).size.width - 30,
                child: FloatingActionButton(
                  isExtended: true,
                  onPressed: () => addToCart(),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40))),
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
            : const SizedBox());
  }

  double size = 0;
  Row createSizes(List<int> val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(
            FontAwesomeIcons.balanceScale,
            size: 20,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          children: [
            SizedBox(
              width: 100,
              child: Slider(
                activeColor: Colors.white,
                inactiveColor: Colors.white,
                value: size,
                onChanged: (s) {
                  setState(() {
                    size = s;
                  });
                },
                max: val.length.toDouble(),
                divisions: val.length,
                label: kListOfSizes[size.toInt()],
              ),
            ),
            const Text(
              'Size',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        )
      ],
    );
  }

  double color = 0;
  Row createColors(List<int> val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(
            FontAwesomeIcons.tint,
            size: 20,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          children: [
            SizedBox(
              width: 100,
              child: Slider(
                activeColor: kListOfColors[color.toInt()],
                inactiveColor: Colors.white,
                value: color,
                onChanged: (s) {
                  setState(() {
                    color = s;
                  });
                },
                max: val.length.toDouble(),
                divisions: val.length,
                label: kListofColorNames[color.toInt()],
              ),
            ),
            const Text(
              'Colors',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        )
      ],
    );
  }

  RaisedButton makeDiscountCards(int key, int value) {
    final bool isActive = key == index;
    return RaisedButton(
      onPressed: () {
        setState(() {
          index = key;
        });
      },
      color: isActive ? kPrimaryColor : Colors.white,
      child: Text(
        '$value%',
        style: TextStyle(
            color: isActive ? Colors.white : kPrimaryColor,
            fontSize: 20,
            fontWeight: isActive ? FontWeight.w900 : FontWeight.w500),
      ),
    );
  }

  Future<void> addToCart() async {
    setState(() {
      adding = true;
    });
    try {
      await APIHandler.addTOCart(
          listingId: listingIds[index],
          shopId: shopIds[index],
          color: color.toInt(),
          size: size.toInt(),
          price: finalPrice,
          name: widget.data['name'] as String,
          image: widget.data['image'] as String);
      _key.currentState
          .showSnackBar(const SnackBar(content: Text('Item added to cart')));
    } catch (e) {
      _key.currentState.showSnackBar(errorSnack(e.toString()));
    }
    setState(() {
      adding = false;
    });
  }

  Container showVariants() => Container(
        decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.2),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Text(
                "Shop Discounts",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
            ),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                children: discounts
                    .asMap()
                    .entries
                    .map((e) => makeDiscountCards(e.key, e.value))
                    .toList(),
              ),
            ),
          ],
        ),
      );

  Container showReviews() => Container(
        height: 600,
        decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.5),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Reviews",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),

            //Review
            FutureBuilder<List<Map<String, dynamic>>>(
                future: APIHandler.getReviewsOfProduct(listingIds[index]),
                builder: (context, snapshot) {
                  // 1 -> Error
                  if (snapshot.hasError) {
                    return kError(snapshot.error.toString());
                  }

                  // 2 -> Success
                  else if (snapshot.hasData) {
                    final List<Map<String, dynamic>> data = snapshot.data;
                    if (data.isEmpty) {
                      return kError('No Reviews yet');
                    } else {
                      final double average =
                          (snapshot.data.last['total'] as int) /
                              snapshot.data.length;
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SmoothStarRating(
                                isReadOnly: true,
                                rating: average,
                                color: Colors.yellow,
                              ),
                              Text(
                                '$average 🌟',
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w900),
                              )
                            ],
                          ),
                          const Divider(
                            color: Colors.white,
                            thickness: 5,
                          ),
                          ListView(
                              shrinkWrap: true,
                              children: data
                                  .asMap()
                                  .entries
                                  .map((e) => makeReviewCards(e.value))
                                  .toList())
                        ],
                      );
                    }
                  }

                  // 3 -> Loading
                  else {
                    return kLoading;
                  }
                })
          ],
        ),
      );

  Container makeReviewCards(Map<String, dynamic> value) {
    final int stars = value['stars'] as int;
    final String review = value['review'] as String;
    final String name = value['name'] as String;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: RichText(
        text: TextSpan(
            style: const TextStyle(
                color: kPrimaryColor,
                fontFamily: 'Mont',
                fontSize: 24,
                fontWeight: FontWeight.w900),
            text: '$stars🌟 $name\n',
            children: [
              TextSpan(
                  text: review,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500)),
            ]),
      ),
    );
  }
}
