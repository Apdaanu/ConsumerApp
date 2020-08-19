import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/constants/connection.dart';
import 'package:freshOk/core/error/exceptions.dart';
import 'package:freshOk/core/token/token_provider.dart';
import 'package:http/http.dart' as http;
import 'package:freshOk/data/models/order/payment_order_model.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

abstract class PaymentRemoteDatasource {
  Future<PaymentOrderModel> createPaymentOrder({
    @required double amount,
    @required String currency,
  });

  Future<Map> capturePayment({
    @required double amount,
    String currency = 'INR',
    @required PaymentSuccessResponse razorpayResponse,
  });
}

class PaymentRemoteDatasourceImpl implements PaymentRemoteDatasource {
  final http.Client client;
  final TokenProvider tokenProvider;

  PaymentRemoteDatasourceImpl({
    @required this.client,
    @required this.tokenProvider,
  });

  @override
  Future<PaymentOrderModel> createPaymentOrder({
    double amount,
    String currency,
  }) async {
    final String token = await tokenProvider.getToken();
    final body = {
      'amount': amount,
      'currency': currency,
    };
    final response = await http.post(
      Connection.endpoint + '/api/customer/paymentorder',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      final PaymentOrderModel paymentOrderModel = PaymentOrderModel.fromJson(
        json.decode(response.body),
      );
      return paymentOrderModel;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map> capturePayment({
    @required double amount,
    String currency = 'INR',
    @required PaymentSuccessResponse razorpayResponse,
  }) async {
    final String token = await tokenProvider.getToken();
    final body = {
      'amount': amount,
      'currency': currency,
      'razorpayResponse': {
        'paymentId': razorpayResponse.paymentId,
        'orderId': razorpayResponse.orderId,
        'signature': razorpayResponse.signature
      },
    };
    final response = await http.post(
      Connection.endpoint +
          '/api/customer/payment/${razorpayResponse.paymentId}/capture',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['paymentResponse'];
    } else {
      throw ServerException();
    }
  }
}
