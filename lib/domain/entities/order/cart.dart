import 'package:flutter/foundation.dart';
import 'package:freshOk/domain/entities/base_model.dart';
import 'package:freshOk/domain/entities/order/delivery_charges.dart';

class Cart extends BaseModel {
  List cart;
  final DeliveryCharges deliveryCharges;
  final double creditLimit;

  Cart({
    @required this.cart,
    @required this.deliveryCharges,
    @required this.creditLimit,
  });

  @override
  List<Object> get props => [cart, deliveryCharges, creditLimit];
}
