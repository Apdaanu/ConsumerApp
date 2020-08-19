import 'package:flutter/cupertino.dart';

import 'base_model.dart';

class UserDetails extends BaseModel {
  String name;
  String profilePhoto;
  final String coverPhoto;
  String alternateMob;
  String address;
  String area;
  String city;
  String landmark;
  String pin;
  String mitraId;
  String referredCode;
  String cityId;
  String areaId;
  final String userId;

  UserDetails({
    @required this.name,
    @required this.profilePhoto,
    @required this.coverPhoto,
    @required this.alternateMob,
    @required this.address,
    @required this.area,
    @required this.landmark,
    @required this.pin,
    @required this.mitraId,
    @required this.referredCode,
    @required this.cityId,
    @required this.areaId,
    @required this.userId,
    @required this.city,
  });

  @override
  List<Object> get props => [
        address,
        alternateMob,
        areaId,
        cityId,
        coverPhoto,
        landmark,
        mitraId,
        name,
        pin,
        area,
        profilePhoto,
        referredCode,
        userId,
        city,
      ];
}
