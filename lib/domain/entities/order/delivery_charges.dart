import 'package:flutter/foundation.dart';
import 'package:freshOk/domain/entities/base_model.dart';

class DeliveryCharges extends BaseModel {
  final double charges;
  final String chargeType;
  final double limit;

  DeliveryCharges({
    @required this.charges,
    @required this.chargeType,
    @required this.limit,
  });

  @override
  List<Object> get props => [
        charges,
        chargeType,
        limit,
      ];
}
