import 'package:flutter/cupertino.dart';
import 'package:freshOk/domain/entities/base_model.dart';
import 'package:freshOk/domain/entities/categories/product.dart';

class Ingredient extends Product {
  final String ingridientQuantity;
  final String value;
  final String type;

  Ingredient({
    @required this.ingridientQuantity,
    @required this.value,
    @required this.type,
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

  @override
  List<Object> get props => [
        ingridientQuantity,
        value,
        type,
      ];
}
