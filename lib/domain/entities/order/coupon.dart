import 'package:flutter/cupertino.dart';
import 'package:freshOk/domain/entities/base_model.dart';

class Coupon extends BaseModel {
  final String id;
  final String code;
  final String image;
  final String desc;
  final String type;
  final CouponProperties properties;

  Coupon({
    @required this.id,
    @required this.code,
    @required this.image,
    @required this.desc,
    @required this.type,
    @required this.properties,
  });

  @override
  List<Object> get props => [
        id,
        code,
        image,
        desc,
        type,
        properties,
      ];
}

class CouponProperties extends BaseModel {
  final double limit;
  final double discount;

  CouponProperties({
    @required this.limit,
    @required this.discount,
  });

  @override
  List<Object> get props => [
        limit,
        discount,
      ];
}
