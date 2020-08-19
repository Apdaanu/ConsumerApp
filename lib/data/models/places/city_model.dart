import 'package:flutter/cupertino.dart';
import 'package:freshOk/data/models/places/area_model.dart';
import 'package:freshOk/domain/entities/place/city.dart';

class CityModel extends City {
  CityModel({
    @required name,
    @required id,
    @required areas,
    parent,
  }) : super(
          name: name,
          id: id,
          areas: areas,
          parent: parent,
        );

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      name: json['cityName'],
      id: json['cityId'],
      areas: json['areas']
          .map(
            (area) => AreaModel.fromJson(
              area,
              json['cityName'],
            ),
          )
          .toList(),
      parent: json['state'],
    );
  }
}
