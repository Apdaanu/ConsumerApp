import 'package:flutter/cupertino.dart';
import 'package:freshOk/data/models/categories/product_model.dart';
import 'package:freshOk/data/models/order/delivery_charges_model.dart';
import 'package:freshOk/domain/entities/order/cart.dart';

class CartModel extends Cart {
  CartModel({
    @required List cart,
    @required DeliveryChargesModel deliveryChargesModel,
    @required double creditLimit,
  }) : super(
          cart: cart,
          deliveryCharges: deliveryChargesModel,
          creditLimit: creditLimit,
        );
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      cart: json['cart'].map((item) => ProductModel.fromJson(item)).toList(),
      deliveryChargesModel:
          DeliveryChargesModel.fromJson(json['deliveryCharges']),
      creditLimit: json['creditLimit'].toDouble() / 100,
    );
  }
}
