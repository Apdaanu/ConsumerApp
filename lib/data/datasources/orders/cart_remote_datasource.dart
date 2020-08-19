import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:freshOk/core/constants/connection.dart';
import 'package:freshOk/core/error/exceptions.dart';
import 'package:freshOk/core/token/token_provider.dart';
import 'package:freshOk/data/models/order/book_slot_model.dart';
import 'package:freshOk/data/models/order/coupon_model.dart';
import 'package:http/http.dart' as http;

import '../../models/order/cart_model.dart';
import '../../models/order/local_cart_model.dart';

abstract class CartRemoteDatasource {
  Future<CartModel> setRemoteCart({
    @required String userId,
    @required LocalCartModel localCartModel,
  });

  Future<List> getCoupons(String userId);

  Future<BookSlotModel> getSlots();
}

class CartRemoteDatasourceImpl implements CartRemoteDatasource {
  final http.Client client;
  final TokenProvider tokenProvider;

  CartRemoteDatasourceImpl({
    @required this.client,
    @required this.tokenProvider,
  });

  @override
  Future<CartModel> setRemoteCart({
    @required String userId,
    @required LocalCartModel localCartModel,
  }) async {
    final String token = await tokenProvider.getToken();
    List prodArgs = List();
    localCartModel.cart.forEach((key, value) {
      prodArgs.add({
        'productId': key,
        'quantity': value,
      });
    });
    final body = json.encode({'cart': prodArgs});
    final response = await client.post(
      Connection.endpoint + '/api/customer/$userId/cart',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: body,
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final CartModel cartModel = CartModel.fromJson(decoded);
      return cartModel;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List> getCoupons(String userId) async {
    final String token = await tokenProvider.getToken();
    final response = await http.get(
      Connection.endpoint + '/api/customer/$userId/coupon',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List coupons =
          decoded.map((item) => CouponModel.fromJson(item)).toList();
      return coupons;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<BookSlotModel> getSlots() async {
    final String token = await tokenProvider.getToken();
    final response = await http.get(
      Connection.endpoint + '/api/customerOrderSlot',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final BookSlotModel slots = BookSlotModel.fromJson(decoded);
      return slots;
    } else {
      throw ServerException();
    }
  }
}
