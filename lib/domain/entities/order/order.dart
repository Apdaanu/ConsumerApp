import 'package:flutter/foundation.dart';

import '../base_model.dart';
import 'book_slot.dart';
import 'delivery_charges.dart';
import 'discount.dart';

class Order extends BaseModel {
  final String id;
  final String orderId;
  final String orderDate;
  List orderStatus;
  final String paymentStatus;
  final String userId;
  final double totalPrice;
  final List order;
  final DeliveryCharges deliveryCharges;
  final Discount discount;
  final String paymentMethod;
  final double usedFreshOkCredit;
  final MitraDetails mitraDetails;
  final Slots slot;
  final String slotDate;

  Order({
    @required this.id,
    @required this.orderId,
    @required this.orderDate,
    @required this.orderStatus,
    @required this.paymentStatus,
    @required this.userId,
    @required this.totalPrice,
    @required this.order,
    @required this.deliveryCharges,
    @required this.discount,
    @required this.paymentMethod,
    @required this.usedFreshOkCredit,
    @required this.mitraDetails,
    @required this.slot,
    @required this.slotDate,
  });

  @override
  List<Object> get props => [
        id,
        orderId,
        orderDate,
        orderStatus,
        paymentStatus,
        userId,
        totalPrice,
        order,
        deliveryCharges,
        discount,
        paymentMethod,
        usedFreshOkCredit,
        mitraDetails,
        slot,
        slotDate,
      ];
}

class MitraDetails extends BaseModel {
  final String name;
  final String profilePhoto;
  final String businessName;
  final int noOfCustomers;
  final String mob;

  MitraDetails({
    @required this.name,
    @required this.profilePhoto,
    @required this.businessName,
    @required this.noOfCustomers,
    @required this.mob,
  });

  @override
  List<Object> get props => [
        name,
        profilePhoto,
        businessName,
        noOfCustomers,
        mob,
      ];
}
