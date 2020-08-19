import 'package:flutter/cupertino.dart';

import '../../domain/entities/user_details.dart';

class UserDetailsModel extends UserDetails {
  UserDetailsModel({
    @required String name,
    @required String profilePhoto,
    @required String coverPhoto,
    @required String alternateMob,
    @required String address,
    @required String area,
    @required String landmark,
    @required String pin,
    @required String mitraId,
    @required String referredCode,
    @required String cityId,
    @required String areaId,
    @required String userId,
    @required String city,
  }) : super(
          name: name,
          address: address,
          alternateMob: alternateMob,
          areaId: areaId,
          cityId: cityId,
          coverPhoto: coverPhoto,
          landmark: landmark,
          mitraId: mitraId,
          pin: pin,
          area: area,
          profilePhoto: profilePhoto,
          referredCode: referredCode,
          userId: userId,
          city: city,
        );

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
      name: json['name'],
      profilePhoto: json['profilePhoto'],
      coverPhoto: json['coverPhoto'],
      alternateMob: json['alternateMob'].toString(),
      address: json['address'],
      area: json['area'],
      landmark: json['landmark'],
      pin: json['pin'],
      mitraId: json['mitraId'],
      referredCode: json['referalCode'],
      cityId: json['cityId'],
      areaId: json['areaId'],
      userId: json['userId'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "profilePhoto": profilePhoto,
      "coverPhoto": coverPhoto,
      "alternateMob": alternateMob,
      "address": address,
      "area": area,
      "landmark": landmark,
      "pin": pin,
      "mitraId": mitraId,
      "referalCode": referredCode,
      "cityId": cityId,
      "areaId": areaId,
      "userId": userId,
      "city": city,
    };
  }
}
