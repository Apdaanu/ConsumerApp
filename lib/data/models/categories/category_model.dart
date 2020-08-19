import 'package:flutter/cupertino.dart';
import 'package:freshOk/domain/entities/categories/category.dart';

import 'sub_category_model.dart';

class CategoryModel extends Category {
  CategoryModel({
    @required String id,
    @required String title,
    @required int orderingNumber,
    @required String uiType,
    @required String type,
    @required String userId,
    @required List<dynamic> subContents,
  }) : super(
          id: id,
          title: title,
          orderingNumber: orderingNumber,
          uiType: uiType,
          type: type,
          userId: userId,
          subContents: subContents,
        );

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'],
      orderingNumber: json['orderingNumber'],
      subContents: json['subContents']
          .map((item) => SubCategoryModel.fromJson(item))
          .toList(),
      title: json['title'],
      type: json['type'],
      uiType: json['uiType'],
      userId: json['userId'],
    );
  }
}
