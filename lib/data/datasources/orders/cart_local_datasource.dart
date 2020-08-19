import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:freshOk/data/models/order/cart_model.dart';
import 'package:freshOk/data/models/order/local_cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CartLocalDatasource {
  Future<LocalCartModel> getLoaclCart();

  Future<LocalCartModel> setLoacalCart({
    @required String productId,
    @required double qty,
  });

  Future<LocalCartModel> removeFromLocalCart(String productId);

  Future<LocalCartModel> clearLocalCart();
}

const CART_CACHE = 'cart';

class CartLocalDatasourceImpl implements CartLocalDatasource {
  final SharedPreferences preferences;

  CartLocalDatasourceImpl(this.preferences);

  @override
  Future<LocalCartModel> getLoaclCart() async {
    final jsonString = preferences.getString(CART_CACHE);
    if (jsonString != null) {
      return Future.value(LocalCartModel(json.decode(jsonString)));
    } else {
      return Future.value(LocalCartModel({}));
    }
  }

  @override
  Future<LocalCartModel> setLoacalCart({String productId, double qty}) {
    final jsonString = preferences.getString(CART_CACHE);
    if (jsonString != null) {
      final Map<String, dynamic> cart = json.decode(jsonString);
      cart[productId] = qty;
      preferences.setString(CART_CACHE, json.encode(cart));
      print('[dbg] in cart DS(set) : $cart');
      return Future.value(LocalCartModel(cart));
    } else {
      final Map<String, dynamic> cart = Map<String, dynamic>();
      cart[productId] = qty;
      preferences.setString(CART_CACHE, json.encode(cart));
      print('[dbg] in cart DS(set) : $cart');
      return Future.value(LocalCartModel(cart));
    }
  }

  @override
  Future<LocalCartModel> removeFromLocalCart(String productId) {
    final jsonString = preferences.getString(CART_CACHE);
    if (jsonString != null) {
      final Map<String, dynamic> cart = json.decode(jsonString);
      cart.remove(productId);
      preferences.setString(CART_CACHE, json.encode(cart));
      print('[dbg] in cart DS(remove) : $cart');
      return Future.value(LocalCartModel(cart));
    }
    final Map<String, dynamic> cart = Map<String, dynamic>();
    return Future.value(LocalCartModel(cart));
  }

  @override
  Future<LocalCartModel> clearLocalCart() {
    preferences.remove(CART_CACHE);
    return null;
  }
}
