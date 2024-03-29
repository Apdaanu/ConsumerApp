import 'package:flutter/foundation.dart';
import 'package:freshOk/domain/entities/mitra/mitra.dart';

class MitraModel extends Mitra {
  MitraModel({
    @required String name,
    @required String businessName,
    @required String mob,
    @required int customers,
    @required String profilePhoto,
    @required String mitraId,
    @required bool active,
  }) : super(
          name: name,
          businessName: businessName,
          mob: mob,
          customers: customers,
          profilePhoto: profilePhoto,
          mitraId: mitraId,
          active: active,
        );

  factory MitraModel.fromJson(Map<String, dynamic> json) {
    return MitraModel(
      name: json['name'],
      businessName: json['nickname'],
      mob: json['mob'].toString(),
      customers: json['customers'].map((item) => 0).toList().length,
      profilePhoto: json['profilePhoto'],
      mitraId: json['userId'],
      active: json['active'],
    );
  }
}
