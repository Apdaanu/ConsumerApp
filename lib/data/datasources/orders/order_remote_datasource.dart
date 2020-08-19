import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/constants/connection.dart';
import 'package:freshOk/core/error/exceptions.dart';
import 'package:freshOk/core/token/token_provider.dart';
import 'package:freshOk/data/models/order/order_model.dart';
import 'package:http/http.dart' as http;

abstract class OrderRemoteDatasource {
  Future<List> getOrders({
    @required String userId,
  });

  Future<OrderModel> getOrderDetails({
    @required String userId,
    @required String orderId,
  });

  Future<OrderModel> placeOrder({
    @required String userId,
    @required String couponId,
    @required double usedFreshOkCredit,
    @required paymentResponse,
    @required String paymentType,
    @required String slotId,
    @required String date,
  });

  Future<void> cancelOrder({
    @required String userId,
    @required String orderId,
  });
}

class OrderRemoteDatasourceImpl implements OrderRemoteDatasource {
  final http.Client client;
  final TokenProvider tokenProvider;

  OrderRemoteDatasourceImpl({
    @required this.client,
    @required this.tokenProvider,
  });

  @override
  Future<List> getOrders({String userId}) async {
    final String token = await tokenProvider.getToken();
    final response = await client.get(
      Connection.endpoint + '/api/customer/$userId/order',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List orders =
          decoded.map((order) => OrderModel.fromJson(order)).toList();
      return orders;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<OrderModel> getOrderDetails({
    String userId,
    String orderId,
  }) async {
    final String token = await tokenProvider.getToken();
    final response = await client.get(
      Connection.endpoint + '/api/customer/$userId/order/$orderId',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final OrderModel orderDetails = OrderModel.fromJson(decoded);
      return orderDetails;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<OrderModel> placeOrder({
    String userId,
    String couponId,
    double usedFreshOkCredit,
    paymentResponse,
    String paymentType,
    @required String slotId,
    @required String date,
  }) async {
    final String token = await tokenProvider.getToken();
    final body = {
      "couponId": couponId,
      "paymentType": paymentType,
      "paymentResponse": paymentResponse,
      "usedFreshOkCredit": usedFreshOkCredit,
      "slotId": slotId,
      "slotDate": date,
    };

    final response = await client.post(
      Connection.endpoint + '/api/customer/$userId/order',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: json.encode(body),
    );
    print('[dbg] : ${response.body}');
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final OrderModel orderDetails = OrderModel.fromJson(decoded);
      return orderDetails;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> cancelOrder({
    String userId,
    String orderId,
  }) async {
    final String token = await tokenProvider.getToken();
    final response = await client.put(
      Connection.endpoint + '/api/customer/$userId/order/$orderId/cancel',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return null;
    } else {
      throw ServerException();
    }
  }
}
