import 'dart:convert';

import 'package:aqua_ly/Api/api_routes.dart';
import 'package:aqua_ly/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

///Handles all API calls to django server
class APIHandler {
  ///--------------------------------------------///
  ///                 USER                       ///
  ///--------------------------------------------///
  //Add Uid
  static Future<void> saveUid(String uid) async {
    final String url = kBaseUrl + kUsers;
    final response = await http.post(url, body: {'uid': uid});
    if (response.statusCode <= 200 || response.statusCode >= 400) {
      throw 'Error - Could not insert UID';
    }
  }

  //Get uid
  static Future<String> getUid(int id) async {
    final String url = kBaseUrl + kUsers + id.toString();
    final response = await http.get(url);
    if (response.statusCode >= 200 && response.statusCode <= 400) {
      final data = json.decode(response.body);
      return data['uid'] as String;
    } else {
      throw 'Error - Could not get user details';
    }
  }

  ///--------------------------------------------///
  ///                 SHOP                       ///
  ///--------------------------------------------///
  //Get Shop Id
  static Future<int> getShopIdForNewUser() async {
    final String url = kBaseUrl + kShop;
    final response = await http.get(url);
    final data = json.decode(response.body) as List;
    if (response.statusCode >= 200 && response.statusCode <= 400) {
      final int id = data.isEmpty ? 0 : data.last['id'] as int;
      SharedPrefs.saveNum('shopId', id + 1);
      return id + 1;
    } else {
      throw 'Error - Could not connect to database';
    }
  }

  //Save Shop Details
  static Future<void> saveShopDetails(String name) async {
    final String url = kBaseUrl + kShop;
    final response = await http.post(url, body: {'name': name, 'revenue': 0});

    if (response.statusCode <= 200 || response.statusCode >= 400) {
      throw 'Error - Could not save shop details';
    }
  }

  //Get Shop revenue
  static Future<String> getShopRevenue() async {
    final int id = await SharedPrefs.getSavedNum('shopId');
    final String url = '$kBaseUrl$kShop$id/';
    final response = await http.get(url);

    if (response.statusCode >= 200 && response.statusCode <= 400) {
      final data = json.decode(response.body);
      final double val = data['revenue'] as double;
      return val.toString();
    } else {
      throw 'Error - Could not get details';
    }
  }

  //Get number of orders
  static Future<String> getNumOrders() async {
    final String url = kBaseUrl + kCart;
    final response = await http.get(url);

    if (response.statusCode >= 200 && response.statusCode <= 400) {
      final data = json.decode(response.body);
      final int id = await SharedPrefs.getSavedNum('shopId');
      int num = 0;
      for (final item in data) {
        final bool active = item['is_active'] as bool;
        if (item['shop_id'] == id && active) {
          num += 1;
        }
      }
      return num.toString();
    } else {
      throw 'Error - Could not load orders';
    }
  }

  //Get Products added by shop
  static Future<List<Map<String, dynamic>>> productsAddedBy() async {
    final int id = await SharedPrefs.getSavedNum('shopId');
    final String url = '$kBaseUrl$kProduct?added_by$id';
    final response = await http.get(url);

    if (response.statusCode >= 200 && response.statusCode <= 400) {
      final data = json.decode(response.body);
      List<Map<String, dynamic>> result = [];
      for (final item in data) {
        final details = {
          'name': item['name'],
          'price': item['price'],
          'verified': item['isAllowed'],
          'image': item['image']
        };
        result.add(details);
      }
      return result;
    } else {
      throw 'Error - Could not get products';
    }
  }

  ///--------------------------------------------///
  ///                 PRODUCTS                   ///
  ///--------------------------------------------///
  //Get All products
  static Future<List<Map<String, dynamic>>> getAllProducts() async {
    final String url = kBaseUrl + kProduct;
    final response = await http.get(url);

    if (response.statusCode >= 200 && response.statusCode <= 400) {
      final data = json.decode(response.body);
      final shopId = await SharedPrefs.getSavedNum('shopId');
      List<Map<String, dynamic>> result = [];

      //Checking and adding each item
      for (final item in data) {
        final String checkUrl =
            '$kBaseUrl$kListing?shop_id=$shopId&product_id=${item['id']}';
        final response = await http.get(checkUrl);

        //Adding only if such a listing does not exist
        if (response.statusCode != 200) {
          final details = {
            'id': item['id'],
            'name': item['name'],
            'price': item['price'],
            'verified': item['isAllowed'],
            'image': item['image']
          };
          result.add(details);
        }
      }
      return result;
    } else {
      throw 'Error - Could not get products';
    }
  }

  //Get Products by id
  static Future<Map<String, dynamic>> getProductById(int id) async {
    final String url = kBaseUrl + kProduct + id.toString();
    final response = await http.get(url);

    if (response.statusCode >= 200 && response.statusCode <= 400) {
      final data = json.decode(response.body);
      final Map<String, dynamic> result = {
        'id': data['id'],
        'name': data['name'],
        'price': data['price'],
        'productType': data['productType'],
        'verified': data['isAllowed'],
        'image': data['image']
      };
      return result;
    } else {
      throw 'Error - Could not get products';
    }
  }

  //Add product
  static Future<void> addProduct(
      {String name, int price, String type, String link}) async {
    final String url = kBaseUrl + kProduct;
    final int id = await SharedPrefs.getSavedNum('shopId');
    final response = await http.post(url, body: {
      'name': name,
      'price': price,
      'image': link,
      'productType': type,
      'added_by': id
    });
    if (response.statusCode <= 200 || response.statusCode >= 400) {
      throw 'Error - Could not add product';
    }
  }

  ///--------------------------------------------///
  ///                 LISTING                    ///
  ///--------------------------------------------///
  //Get Listings
  static Future<List<Map<String, dynamic>>> getListings() async {
    final int shopId = await SharedPrefs.getSavedNum('shopId');
    final String url = '$kBaseUrl$kListing?shop_id=$shopId';
    final listResponse = await http.get(url);

    //Getting all listings of shop
    if (listResponse.statusCode >= 200 && listResponse.statusCode <= 400) {
      final List<Map<String, dynamic>> result = [];
      final List listingData = json.decode(listResponse.body) as List;

      //Finding product details
      for (final listItem in listingData) {
        final int productId = listItem['product_id'] as int;
        final Map<String, dynamic> productData =
            await getProductById(productId);
        result.add({
          'id': listItem['id'] as int,
          'productId': productId,
          'name': productData['name'] as String,
          'price': productData['price'] as int,
          'image': productData['image'] as String,
          'productType': productData['productType'] as String,
          'color': listItem['color'] as String,
          'size': listItem['size'] as String,
          'discount': listItem['discount'] as int,
          'stock': listItem['stock'] as int
        });
      }
      return result;
    } else {
      throw 'Error - Could not find listings';
    }
  }

  //Get listing by id
  static Future<Map<String, dynamic>> getListingById(
      {int listingId, int userId, int cartId, bool isActive}) async {
    final String url = kBaseUrl + kListing + listingId.toString();
    final response = await http.get(url);
    if (response.statusCode >= 200 && response.statusCode <= 400) {
      final data = json.decode(response.body);
      final Map<String, dynamic> productData =
          await getProductById(data['product_id'] as int);
      final String uid = await getUid(userId);

      final _doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final _data = _doc.data();
      return {
        'cartId': cartId,
        'userId': userId,
        'listingId': listingId,
        'isActive': isActive,
        'location': _data['location'].toString(),
        'userName': _data['name'].toString(),
        'name': productData['name'] as String,
        'image': productData['image'] as String,
        'price': productData['price'] as int,
        'color': data['color'] as String,
        'size': data['size'] as String,
        'discount': data['discount'] as int,
        'stock': data['stock'] as int
      };
    } else {
      throw 'Error - Could not find listing';
    }
  }

  //Add Listing
  static Future<void> addListing(
      {int productId,
      String colors,
      String sizes,
      int stock,
      int discount}) async {
    final int shopId = await SharedPrefs.getSavedNum('shopId');
    final String url = kBaseUrl + kListing;
    final response = await http.post(url, body: {
      "product_id": productId,
      "shop_id": shopId,
      "color": colors,
      "size": sizes,
      "stock": stock,
      "discount": discount,
    });
    if (response.statusCode < 200 || response.statusCode > 400) {
      throw 'Error- Could not add listing';
    }
  }

  //Edit listing
  static Future<void> editListing(
      {int listingId,
      int productId,
      String colors,
      String sizes,
      int stock,
      int discount}) async {
    final String url = kBaseUrl + kListing + listingId.toString();
    final int shopId = await SharedPrefs.getSavedNum('shopId');
    final response = await http.put(url, body: {
      'product_id': productId.toString(),
      'shop_id': shopId.toString(),
      'color': colors,
      'size': sizes,
      'stock': stock.toString(),
      'discount': discount.toString()
    });

    if (response.statusCode < 200 || response.statusCode > 400) {
      throw 'Error - could not update details';
    }
  }

  ///--------------------------------------------///
  ///                 ORDERS                     ///
  ///--------------------------------------------///
  //Get products for shop
  static Future<List<Map<String, dynamic>>> getOrdersForShop(
      {bool getActive}) async {
    final int shopId = await SharedPrefs.getSavedNum('shopId');
    final String url = '$kBaseUrl$kCart?shop_id=$shopId';
    final response = await http.get(url);
    if (response.statusCode >= 200 && response.statusCode <= 400) {
      final data = json.decode(response.body);
      List<Map<String, dynamic>> result = [];
      for (final item in data) {
        if (getActive) {
          if (item['is_active'] as bool) {
            result.add(
              await getListingById(
                  listingId: item['listing_id'] as int,
                  userId: item['user_id'] as int,
                  cartId: item['id'] as int,
                  isActive: item['is_active'] as bool),
            );
          }
        } else {
          result.add(await getListingById(
              listingId: item['listing_id'] as int,
              userId: item['user_id'] as int,
              cartId: item['id'] as int,
              isActive: item['is_active'] as bool));
        }
      }
      return result;
    } else {
      throw 'Error - Could not find items in cart';
    }
  }

  //Mark as delivered
  static Future<void> markDelivered({int cart, int user, int listing}) async {
    final String url = '$kBaseUrl$kCart$cart/';
    final int shopId = await SharedPrefs.getSavedNum('shopId');
    final response = await http.put(url, body: {
      'user_id': user.toString(),
      'listing_id': listing.toString(),
      'shop_id': shopId.toString(),
      'is_active': false.toString()
    });
    if (response.statusCode < 200 || response.statusCode > 400) {
      throw 'Error - Could not mark as delivered';
    }
  }
}
