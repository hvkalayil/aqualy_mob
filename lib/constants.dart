import 'package:flutter/material.dart';

const List<Color> kListOfColors = [
  Colors.redAccent,
  Colors.amber,
  Colors.brown,
  Colors.green,
  Colors.blueAccent,
  Colors.purpleAccent,
];

const List<String> kListofColorNames = [
  'Red',
  'Amber',
  'Brown',
  'Green',
  'Blue',
  'Purple',
];

const List<String> kListOfSizes = ['Small', 'Medium', 'Large', 'XLarge'];

List<int> parseIntFromString(String data) {
  // ignore: prefer_final_locals
  List<int> result = [];
  for (final String item in data.split(',')) {
    try {
      result.add(int.parse(item));
    } catch (e) {
      continue;
    }
  }
  return result;
}

String createString(List<int> data) {
  // ignore: prefer_final_locals
  StringBuffer buff = StringBuffer();
  for (final int item in data) {
    buff.write(item);
    buff.write(',');
  }
  final String result = buff.toString();
  buff.clear();
  return result;
}

const String kInCart = 'In Cart';
const String kOut = 'Out for Delivery';
const String kDelivered = 'Delivered';

const List<Map<String, dynamic>> searchLoading = [
  {'loading': true}
];
