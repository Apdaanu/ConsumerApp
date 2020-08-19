import 'package:flutter/foundation.dart';
import 'package:freshOk/domain/entities/order/delivery_charges.dart';

class DeliveryChargesModel extends DeliveryCharges {
  DeliveryChargesModel({
    @required double charges,
    @required String chargeType,
    @required double limit,
  }) : super(
          charges: charges,
          chargeType: chargeType,
          limit: limit,
        );

  factory DeliveryChargesModel.fromJson(Map<String, dynamic> json) {
    return DeliveryChargesModel(
      charges: json['charges'].toDouble(),
      chargeType: json['chargeType'],
      limit: json['limit'] != null ? json['limit'].toDouble() : 0,
    );
  }
}
