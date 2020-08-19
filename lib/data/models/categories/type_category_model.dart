import 'package:flutter/foundation.dart';
import 'package:freshOk/core/util/util.dart';

import '../../../domain/entities/categories/type_category.dart';

class TypeCategoryModel extends TypeCategory {
  TypeCategoryModel({
    @required String id,
    @required String name,
  }) : super(
          id: id,
          name: name,
        );

  factory TypeCategoryModel.fromJson(Map<String, dynamic> json) {
    return TypeCategoryModel(
      id: json['_id'],
      name: Util.capitalize(json['name']),
    );
  }
}
