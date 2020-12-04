import 'package:flutter/material.dart';

const List<Color> kListOfColors = [
  Colors.redAccent,
  Colors.amber,
  Colors.brown,
  Colors.green,
  Colors.blueAccent,
  Colors.purpleAccent,
];

const List<String> kListOfSizes = ['Small', 'Medium', 'Large', 'XLarge'];

List<int> parseIntFromString(String data) {
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
  StringBuffer buff = StringBuffer();
  for (final int item in data) {
    buff.write(item);
    buff.write(',');
  }
  final String result = buff.toString();
  buff.clear();
  return result;
}
