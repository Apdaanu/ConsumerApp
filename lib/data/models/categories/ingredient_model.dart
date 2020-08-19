import 'package:flutter/foundation.dart';
import 'package:freshOk/domain/entities/categories/ingredient.dart';

class IngredientModel extends Ingredient {
  IngredientModel({
    @required String ingridientQuantity,
    @required String value,
    @required String type,
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
          ingridientQuantity: ingridientQuantity,
          value: value,
          type: type,
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

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      ingridientQuantity: json['quantity'],
      value: json['value'],
      type: json['type'],
      productId: json['productId'],
      name: json['name'],
      image: json['image'],
      unitPrice: json['unitPrice'] != null ? json['unitPrice'].toDouble() : 0,
      unit: json['unit'],
      discount: json['discount'] != null ? json['discount'].toDouble() : 0,
      discountedPrice: json['discountedPrice'] != null
          ? json['discountedPrice'].toDouble()
          : 0,
      unitQty: json['unitQty'] != null ? json['unitQty'].toDouble() : 0,
      minQty: json['minQty'] != null ? json['minQty'].toDouble() : 0,
      maxQty: json['maxQty'] != null ? json['maxQty'].toDouble() : 0,
      incrementVal:
          json['incrementVal'] != null ? json['incrementVal'].toDouble() : 0,
      checked: json['checked'],
      inStock: json['inStock'],
      categories: json['categories'],
      quantity: 0.0,
    );
  }
}
