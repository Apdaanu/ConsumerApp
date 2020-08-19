import 'package:flutter/foundation.dart';
import 'package:freshOk/domain/entities/order/payment_order.dart';

class PaymentOrderModel extends PaymentOrder {
  PaymentOrderModel({
    @required String id,
    @required double amount,
  }) : super(
          id: id,
          amount: amount,
        );

  factory PaymentOrderModel.fromJson(Map<String, dynamic> json) {
    return PaymentOrderModel(
      amount: json['amount'].toDouble(),
      id: json['id'],
    );
  }
}
