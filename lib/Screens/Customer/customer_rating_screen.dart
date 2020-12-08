import 'package:aqua_ly/Api/api_handler.dart';
import 'package:aqua_ly/constants.dart';
import 'package:aqua_ly/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RatingScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const RatingScreen({Key key, this.data}) : super(key: key);
  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double rating = 0;
  String review = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: const Text('Rate Product'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Heading
              Container(
                width: MediaQuery.of(context).size.width,
                height: 120,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.network(
                      widget.data['image'] as String,
                      errorBuilder: (context, widget, error) =>
                          Image.asset(kDefImg),
                    ),
                    Text(
                      widget.data['name'] as String,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                    ),
                    Text(
                      '₹${widget.data['price'] as int}',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 50,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.5),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor:
                              kListOfColors[widget.data['color'] as int],
                        ),
                        Text(
                          kListofColorNames[widget.data['color'] as int],
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w900),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 50,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.5),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          kListOfSizes[widget.data['size'] as int],
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w900),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              Column(
                children: [
                  SmoothStarRating(
                    color: kPrimaryColor,
                    size: 60,
                    onRated: (input) => rating = input,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        maxLines: 8,
                        decoration: const InputDecoration(
                            labelText: 'Review', hintText: 'Leave Your review'),
                        textInputAction: TextInputAction.done,
                        onSaved: (input) => review = input,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onDoneClick(),
        child: const Icon(FontAwesomeIcons.check),
      ),
    );
  }

  Future<void> onDoneClick() async {
    if (rating == 0) {
      _key.currentState.showSnackBar(errorSnack('Please leave a rating'));
    } else {
      _formKey.currentState.save();
      try {
        await APIHandler.addReview(
            lId: widget.data['listing_id'] as int,
            review: review,
            rating: rating.toInt());
        Navigator.pop(context);
      } catch (e) {
        _key.currentState.showSnackBar(errorSnack(e.toString()));
      }
    }
  }
}
