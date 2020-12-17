import 'dart:convert';

import 'package:aqua_ly/Api/api_routes.dart';
import 'package:aqua_ly/constants.dart';
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
    if (response.statusCode >= 200 && response.statusCode <= 400) {
      final data = json.decode(response.body);
      await SharedPrefs.saveStr('uid', data['id'].toString());
    } else {
      throw 'Error - Could not insert UID';
    }
  }

  static Future<void> getIdOfUser(String uid) async {
    final String url = '$kBaseUrl$kUsers?uid=$uid';
    final response = await http.get(url);
    if (response.statusCode >= 200 && response.statusCode <= 400) {
      final data = json.decode(response.body);
      await SharedPrefs.saveStr('uid', data[0]['id'].toString());
    } else {
      throw 'Error - Could not get id from database';
    }
  }

  //Get uid
  static Future<String> getUid(int id) async {
    final String url = '$kBaseUrl$kUsers$id/';
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
    final response =
        await http.post(url, body: {'name': name, 'revenue': 0.toString()});

    if (response.statusCode < 200 || response.statusCode > 400) {
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
      await SharedPrefs.saveDouble('revenue', val);
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
        final bool active = (item['status'] as String) == kOut;
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
      // ignore: prefer_final_locals
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
  //Get All products for shop user
  static Future<List<Map<String, dynamic>>> getAllProductsForShopUser() async {
    final String url = '$kBaseUrl$kProduct?isAllowed=true';
    final response = await http.get(url);

    if (response.statusCode >= 200 && response.statusCode <= 400) {
      final data = json.decode(response.body);

      //Getting all products added by shop
      final shopId = await SharedPrefs.getSavedNum('shopId');
      final String checkUrl = '$kBaseUrl$kListing?shop_id=$shopId';
      final listResponse = await http.get(checkUrl);
      final listingData = json.decode(listResponse.body);
      // ignore: prefer_final_locals
      List<int> addedProducts = [];
      for (final listItem in listingData) {
        addedProducts.add(listItem['product_id'] as int);
      }
      // ignore: prefer_final_locals
      List<Map<String, dynamic>> result = [];

      //Checking and adding each item
      for (final item in data) {
        if (addedProducts.contains(item['id'] as int)) {
          continue;
        } else {
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

  //Get All products for customer
  static Future<List<Map<String, dynamic>>> getAllProducts(
      {String status}) async {
    final String url = status == 'Fishes'
        ? '$kBaseUrl$kProduct?productType=F'
        : '$kBaseUrl$kProduct?productType=A';
    final response = await http.get(url);
    if (response.statusCode >= 200 && response.statusCode <= 400) {
      final data = json.decode(response.body);
      // ignore: prefer_final_locals
      List<Map<String, dynamic>> result = [];
      for (final item in data) {
        final details = {
          'id': item['id'],
          'image': item['image'],
          'name': item['name'],
          'price': item['price'],
        };
        result.add(details);
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
      {String name, String price, String type, String link}) async {
    final String url = kBaseUrl + kProduct;
    final int id = await SharedPrefs.getSavedNum('shopId');
    final response = await http.post(url, body: {
      'name': name,
      'price': price,
      'image': link,
      'productType': type,
      'added_by': id.toString()
    });
    if (response.statusCode < 200 || response.statusCode > 400) {
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
      {int listingId, int userId, int cartId, String status}) async {
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
        'status': status,
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
      String stock,
      String discount}) async {
    final int shopId = await SharedPrefs.getSavedNum('shopId');
    final String url = kBaseUrl + kListing;
    final response = await http.post(url, body: {
      "product_id": productId.toString(),
      "shop_id": shopId.toString(),
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
      String stock,
      String discount}) async {
    final String url = '$kBaseUrl$kListing$listingId/';
    final int shopId = await SharedPrefs.getSavedNum('shopId');
    final response = await http.put(url, body: {
      'product_id': productId.toString(),
      'shop_id': shopId.toString(),
      'color': colors,
      'size': sizes,
      'stock': stock,
      'discount': discount
    });

    if (response.statusCode < 200 || response.statusCode > 400) {
      throw 'Error - could not update details';
    }
  }

  //Get fish info
  static Future<Map<String, dynamic>> getFishInfo(int pId) async {
    final String url = '$kBaseUrl$kListing?ordering=-discount&product_id=$pId';
    final response = await http.get(url);
    if (response.statusCode >= 200 && response.statusCode <= 400) {
      final data = json.decode(response.body);
      final List<int> listingList = [];
      final List<int> shopList = [];
      final List<List<int>> colorList = [];
      final List<List<int>> sizeList = [];
      final List<int> stockList = [];
      final List<int> discountList = [];
      for (final item in data) {
        listingList.add(item['id'] as int);
        shopList.add(item['shop_id'] as int);
        colorList.add(parseIntFromString(item['color'] as String));
        sizeList.add(parseIntFromString(item['size'] as String));
        stockList.add(item['stock'] as int);
        discountList.add(item['discount'] as int);
      }
      return {
        'id': listingList,
        'shop_id': shopList,
        'colors': colorList,
        'sizes': sizeList,
        'stocks': stockList,
        'discounts': discountList,
      };
    } else {
      throw 'Error - Could not get listings';
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
      // ignore: prefer_final_locals
      List<Map<String, dynamic>> result = [];
      for (final item in data) {
        final String status = item['status'] as String;
        if (getActive) {
          if (status == kOut) {
            result.add(
              await getListingById(
                  listingId: item['listing_id'] as int,
                  userId: item['user_id'] as int,
                  cartId: item['id'] as int,
                  status: status),
            );
          }
        } else {
          if (status != kInCart) {
            result.add(await getListingById(
                listingId: item['listing_id'] as int,
                userId: item['user_id'] as int,
                cartId: item['id'] as int,
                status: status));
          }
        }
      }
      return result;
    } else {
      throw 'Error - Could not find items in cart';
    }
  }

  static Future<List<Map<String, dynamic>>> getOrdersForCustomer(
      {bool getEverything}) async {
    final String uid = await SharedPrefs.getSavedStr('uid') ?? '1';
    final String url = '$kBaseUrl$kCart?user_id=$uid';
    final response = await http.get(url);
    if (response.statusCode >= 200 && response.statusCode <= 400) {
      final data = json.decode(response.body);
      // ignore: prefer_final_locals
      List<Map<String, dynamic>> result = [];
      int total = 0;
      for (final item in data) {
        if (getEverything) {
          total += item['price'] as int;
          result.add({
            'cart_id': item['id'],
            'listing_id': item['listing_id'],
            'shop_id': item['shop_id'],
            'color': item['color'],
            'size': item['size'],
            'price': item['price'],
            'name': item['name'],
            'image': item['image'],
            'status': item['status'],
            'finalPrice': total,
          });
        } else {
          final String status = item['status'] as String;
          if (status == kInCart) {
            total += item['price'] as int;
            result.add({
              'cart_id': item['id'],
              'listing_id': item['listing_id'],
              'shop_id': item['shop_id'],
              'color': item['color'],
              'size': item['size'],
              'price': item['price'],
              'name': item['name'],
              'image': item['image'],
              'status': item['status'],
              'finalPrice': total,
            });
          }
        }
      }
      return result;
    } else {
      throw 'Error - Could not get orders';
    }
  }

  //Add order
  static Future<void> addTOCart(
      {int listingId,
      int shopId,
      int color,
      int size,
      int price,
      String name,
      String image}) async {
    final String url = kBaseUrl + kCart;
    final String userId = await SharedPrefs.getSavedStr('uid');
    final response = await http.post(url, body: {
      'user_id': userId,
      'listing_id': listingId.toString(),
      'shop_id': shopId.toString(),
      'color': color.toString(),
      'size': size.toString(),
      'price': price.toString(),
      'name': name,
      'image': image,
    });
    if (response.statusCode < 200 || response.statusCode > 400) {
      throw 'Error - Could not add to cart';
    }
  }

  //Mark as out for delivery
  static Future<void> markAsOutForDelivery(int id) async {
    final String url = '$kBaseUrl$kCart$id/';
    final response = await http.patch(url, body: {'status': kOut});
    if (response.statusCode < 200 || response.statusCode > 400) {
      throw 'Error - Could not  checkout';
    }
  }

  //Mark as delivered
  static Future<void> markDelivered(
      {int cart, int price, int listingId, int stock}) async {
    //Marking as Delivered
    final String url = '$kBaseUrl$kCart$cart/';
    final response = await http.patch(url, body: {'status': kDelivered});
    if (response.statusCode >= 200 && response.statusCode <= 400) {
      //Adding revenue to shop
      final int id = await SharedPrefs.getSavedNum('shopId');
      final String changeRevenue = '$kBaseUrl$kShop$id/';
      final double val = await SharedPrefs.getSavedDouble('revenue') + price;
      final revenueResponse =
          await http.patch(changeRevenue, body: {'revenue': val.toString()});
      if (revenueResponse.statusCode >= 200 &&
          revenueResponse.statusCode <= 400) {
        //Adjusting stock
        final stockUrl = '$kBaseUrl$kListing$listingId/';
        final stockResponse =
            await http.patch(stockUrl, body: {'stock': (stock - 1).toString()});

        if (stockResponse.statusCode < 200 || stockResponse.statusCode > 400) {
          throw 'Error - Could not adjust stock';
        }
      } else {
        throw 'Error - Could not add revenue';
      }
    } else {
      throw 'Error - Could not mark as delivered';
    }
  }

  //RemoveItem
  static Future<void> removeFromCart(int cartId) async {
    final String url = '$kBaseUrl$kCart$cartId/';
    final response = await http.delete(url);
    if (response.statusCode < 200 || response.statusCode > 400) {
      throw 'Error - Could not remove item';
    }
  }

  ///--------------------------------------------///
  ///                 REVIEW                     ///
  ///--------------------------------------------///
  static Future<void> addReview({int lId, String review, int rating}) async {
    final String url = kBaseUrl + kRating;
    final String name = await SharedPrefs.getSavedStr('name');
    final response = await http.post(url, body: {
      'listing_id': lId.toString(),
      'review': review,
      'name': name,
      'stars': rating.toString(),
    });

    if (response.statusCode < 200 || response.statusCode > 400) {
      throw 'Error - Could not add review';
    }
  }

  static Future<List<Map<String, dynamic>>> searchProduct(String query) async {
    final String url = '$kBaseUrl$kProduct?search=$query';
    final response = await http.get(url);
    if (response.statusCode >= 200 && response.statusCode <= 400) {
      final data = json.decode(response.body);
      // ignore: prefer_final_locals
      List<Map<String, dynamic>> result = [];
      for (final item in data) {
        if (item['isAllowed'] as bool) {
          result.add({
            'product_id': item['id'],
            'name': item['name'],
            'price': item['price'],
            'image': item['image'],
          });
        }
      }
      return result;
    } else {
      throw 'Error - Could not find anything';
    }
  }

  //Get Reviews for a product
  static Future<List<Map<String, dynamic>>> getReviewsOfProduct(int id) async {
    final String url = '$kBaseUrl$kRating?listing_id=$id';
    final response = await http.get(url);
    if (response.statusCode >= 200 && response.statusCode <= 400) {
      final data = json.decode(response.body);
      // ignore: prefer_final_locals
      List<Map<String, dynamic>> result = [];
      int total = 0;
      for (final item in data) {
        final int stars = (item['stars'] as double).toInt();
        total += stars;
        result.add({
          'name': item['name'],
          'review': item['review'],
          'stars': stars,
          'total': total
        });
      }
      return result;
    } else {
      throw 'Error - Could not get reviews';
    }
  }

  static Future<double> getShopRating() async {
    final int id = await SharedPrefs.getSavedNum('shopId');
    final String url = '$kBaseUrl$kListing?shop_id=$id';
    final response = await http.get(url);
    if (response.statusCode >= 200 && response.statusCode <= 400) {
      final data = json.decode(response.body);
      // ignore: prefer_final_locals
      List<int> lIds = [];
      for (final item in data) {
        lIds.add(item['id'] as int);
      }
      //Returning 0 if bo rating
      if (lIds.isEmpty) return 0;

      final String reviewUrl = kBaseUrl + kRating;
      final reviewResponse = await http.get(reviewUrl);
      if (response.statusCode >= 200 && response.statusCode <= 400) {
        final reviewData = json.decode(reviewResponse.body);
        double stars = 0;
        int total = 0;
        for (final reviewItem in reviewData) {
          if (lIds.contains(reviewItem['listing_id'] as int)) {
            stars += reviewItem['stars'] as double;
            total += 1;
          }
        }
        return stars / total;
      } else {
        throw 'Error - Could not get reviews';
      }
    } else {
      throw 'Error - Could not get listings';
    }
  }
}
