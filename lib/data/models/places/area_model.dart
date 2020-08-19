import 'package:flutter/cupertino.dart';
import 'package:freshOk/domain/entities/place/area.dart';

class AreaModel extends Area {
  AreaModel({
    @required String name,
    @required String id,
    @required String parent,
  }) : super(
          name: name,
          id: id,
          parent: parent,
        );

  factory AreaModel.fromJson(Map<String, dynamic> json, String parent) {
    return AreaModel(
      name: json['areaName'],
      id: json['areaId'],
      parent: parent,
    );
  }
}
