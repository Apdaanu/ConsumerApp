import 'package:flutter/foundation.dart';
import 'package:freshOk/domain/entities/order/discount.dart';

class DiscountModel extends Discount {
  DiscountModel({
    @required String discountType,
    @required double discountValue,
  }) : super(discountType: discountType, discountValue: discountValue);

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      discountType: json['discountType'],
      discountValue: json['discountValue'].toDouble(),
    );
  }
}
