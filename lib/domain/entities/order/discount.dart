import 'package:flutter/foundation.dart';
import 'package:freshOk/domain/entities/base_model.dart';

class Discount extends BaseModel {
  final String discountType;
  final double discountValue;

  Discount({
    @required this.discountType,
    @required this.discountValue,
  });

  @override
  List<Object> get props => [
        discountType,
        discountValue,
      ];
}
