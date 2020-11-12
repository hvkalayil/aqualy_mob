import 'package:aqua_ly/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SellerHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          makeMessage(
              context: context,
              title: 'Your\nBest Selling\nProduct',
              msg: 'Bluefin Guppy',
              asset: 'bestSeller.png'),
          makeMessage(
              context: context,
              title: 'Your\nTotal Revenue',
              msg: 'Rs 10,000',
              asset: 'revenue.png'),
          makeMessage(
              context: context,
              title: 'Your\nPending Orders',
              msg: '10',
              asset: 'pending.png'),
        ],
      ),
    );
  }

  Container makeMessage(
      {BuildContext context, String title, String msg, String asset}) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(color: Colors.black45, blurRadius: 6, spreadRadius: 6)
          ],
          color: kPrimaryColor,
          image: DecorationImage(
              image: AssetImage('assets/graphics/$asset'), scale: 3),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          Text(
            msg,
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
          )
        ],
      ),
    );
  }
}
