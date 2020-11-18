import 'dart:convert';

import 'package:aqua_ly/Api/api_routes.dart';
import 'package:http/http.dart' as http;

///Handles all API calls to django server
class APIHandler {
  static Future<void> getShopIdForNewUser() async {
    print('here');
    final String url = kBaseUrl + kGetShopId;
    final response = await http.get(url);
    print(response.body);
    final data = json.decode(response.body);
    print(data.runtimeType);
  }
}
