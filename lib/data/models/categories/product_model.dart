import 'package:flutter/foundation.dart';
import 'package:freshOk/domain/entities/categories/product.dart';

class ProductModel extends Product {
  ProductModel({
    @required String productId,
    @required String name,
    @required String image,
    @required double unitPrice,
    @required String unit,
    @required double discount,
    @required double discountedPrice,
    @required double unitQty,
    @required double minQty,
    @required double maxQty,
    @required double incrementVal,
    @required bool checked,
    @required bool inStock,
    @required List categories,
    @required double quantity,
  }) : super(
          productId: productId,
          name: name,
          image: image,
          unitPrice: unitPrice,
          unit: unit,
          discount: discount,
          discountedPrice: discountedPrice,
          unitQty: unitQty,
          minQty: minQty,
          maxQty: maxQty,
          incrementVal: incrementVal,
          checked: checked,
          inStock: inStock,
          categories: categories,
          quantity: quantity,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      categories: json['categories'] != null
          ? json['categories'].map((category) => category).toList()
          : [],
      checked: json['checked'],
      discount: json['discount'].toDouble(),
      discountedPrice: json['discountedPrice'].toDouble(),
      image: json['image'],
      inStock: json['inStock'],
      incrementVal: json['incrementVal'].toDouble(),
      maxQty: json['maxQty'].toDouble(),
      minQty: json['minQty'].toDouble(),
      name: json['name'],
      productId: json['productId'],
      unit: json['unit'],
      unitPrice: json['unitPrice'].toDouble(),
      unitQty: json['unitQty'].toDouble(),
      quantity: json['quantity'] != null ? json['quantity'].toDouble() : 0,
    );
  }
}
