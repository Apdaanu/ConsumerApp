import 'package:flutter/foundation.dart';

import '../../../domain/entities/order/coupon.dart';

class CouponModel extends Coupon {
  CouponModel({
    @required String id,
    @required String code,
    @required String image,
    @required String desc,
    @required String type,
    @required CouponPropertiesModel properties,
  }) : super(
          id: id,
          code: code,
          image: image,
          desc: desc,
          type: type,
          properties: properties,
        );

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['_id'],
      code: json['code'],
      image: json['image'],
      desc: json['desc'],
      type: json['type'],
      properties: CouponPropertiesModel.fromJson(json['properties']),
    );
  }
}

class CouponPropertiesModel extends CouponProperties {
  CouponPropertiesModel({
    @required double limit,
    @required double discount,
  }) : super(
          limit: limit,
          discount: discount,
        );

  factory CouponPropertiesModel.fromJson(Map<String, dynamic> json) {
    return CouponPropertiesModel(
      limit: json['limit'] != null ? json['limit'].toDouble() : 0,
      discount: json['discount'] != null ? json['discount'].toDouble() : 0,
    );
  }
}
