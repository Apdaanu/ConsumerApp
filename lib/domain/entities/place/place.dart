import 'package:flutter/cupertino.dart';
import 'package:freshOk/domain/entities/base_model.dart';

class Place extends BaseModel {
  final String name;
  final String id;
  final String parent;

  Place({
    @required this.name,
    @required this.id,
    @required this.parent,
  });

  @override
  List<Object> get props => [
        name,
        id,
        parent,
      ];
}
