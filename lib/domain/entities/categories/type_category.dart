import 'package:flutter/foundation.dart';

import '../base_model.dart';

class TypeCategory extends BaseModel {
  final String name;
  final String id;

  TypeCategory({
    @required this.name,
    @required this.id,
  });

  @override
  List<Object> get props => [
        name,
        id,
      ];
}
