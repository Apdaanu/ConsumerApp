import 'package:flutter/cupertino.dart';

import '../base_model.dart';

class Product extends BaseModel {
  final String productId;
  final String name;
  final String image;
  final double unitPrice;
  final String unit;
  final double discount;
  final double discountedPrice;
  final double unitQty;
  final double minQty;
  final double maxQty;
  final double incrementVal;
  final bool checked;
  final bool inStock;
  final List categories;
  double quantity;

  Product({
    @required this.productId,
    @required this.name,
    @required this.image,
    @required this.unitPrice,
    @required this.unit,
    @required this.discount,
    @required this.discountedPrice,
    @required this.unitQty,
    @required this.minQty,
    @required this.maxQty,
    @required this.incrementVal,
    @required this.checked,
    @required this.inStock,
    @required this.categories,
    @required this.quantity,
  });

  @override
  List<Object> get props => [
        productId,
        name,
        image,
        unitPrice,
        unit,
        discount,
        discountedPrice,
        unitQty,
        minQty,
        maxQty,
        incrementVal,
        checked,
        inStock,
        categories,
        quantity,
      ];
}
