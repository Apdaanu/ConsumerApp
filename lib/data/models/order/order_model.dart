import 'package:flutter/cupertino.dart';
import 'package:freshOk/data/models/order/book_slot_model.dart';
import 'package:freshOk/data/models/order/delivery_charges_model.dart';
import 'package:freshOk/data/models/order/discount_model.dart';
import 'package:freshOk/domain/entities/order/order.dart';

import '../categories/product_model.dart';

class OrderModel extends Order {
  OrderModel({
    @required String id,
    @required String orderId,
    @required String orderDate,
    @required List orderStatus,
    @required String paymentStatus,
    @required String userId,
    @required double totalPrice,
    @required List order,
    @required DeliveryChargesModel deliveryCharges,
    @required DiscountModel discount,
    @required String paymentMethod,
    @required double usedFreshOkCredit,
    @required MitraDetailsModel mitraDetails,
    @required SlotsModel slot,
    @required String slotDate,
  }) : super(
          id: id,
          orderId: orderId,
          orderDate: orderDate,
          orderStatus: orderStatus,
          paymentStatus: paymentStatus,
          userId: userId,
          totalPrice: totalPrice,
          order: order,
          deliveryCharges: deliveryCharges,
          discount: discount,
          paymentMethod: paymentMethod,
          usedFreshOkCredit: usedFreshOkCredit,
          mitraDetails: mitraDetails,
          slot: slot,
          slotDate: slotDate,
        );

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'],
      orderId: json['orderId'],
      userId: json['userId'],
      orderStatus: json['orderStatus'].map((status) => status).toList(),
      orderDate: json['orderDate'],
      totalPrice: 0.0,
      paymentStatus: json['paymentStatus'],
      paymentMethod: json['paymentMethod'],
      order: json['order']
          .map((product) => ProductModel.fromJson(product))
          .toList(),
      deliveryCharges: DeliveryChargesModel.fromJson(json["deliveryCharges"]),
      discount: DiscountModel.fromJson(json["discount"]),
      usedFreshOkCredit: json["usedFreshOkCredit"].toDouble(),
      mitraDetails: json['mitraDetails'] != null
          ? MitraDetailsModel.fromJson(json['mitraDetails'])
          : null,
      slot: json['slot'] != null ? SlotsModel.fromJson(json['slot']) : null,
      slotDate: json['slotDate'],
    );
  }
}

class MitraDetailsModel extends MitraDetails {
  MitraDetailsModel({
    @required String name,
    @required String profilePhoto,
    @required String businessName,
    @required int noOfCustomers,
    @required String mob,
  }) : super(
          name: name,
          profilePhoto: profilePhoto,
          businessName: businessName,
          noOfCustomers: noOfCustomers,
          mob: mob,
        );

  factory MitraDetailsModel.fromJson(Map<String, dynamic> json) {
    return MitraDetailsModel(
      name: json['name'],
      profilePhoto: json['profilePhoto'],
      businessName: json['business_name'],
      noOfCustomers: json['noOfCustomers'],
      mob: json['mob'].toString(),
    );
  }
}
