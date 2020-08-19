import 'package:flutter/foundation.dart';
import 'package:freshOk/domain/entities/base_model.dart';

class Mitra extends BaseModel {
  final String name;
  final String businessName;
  final String mob;
  int customers;
  final String profilePhoto;
  final String mitraId;

  Mitra({
    @required this.name,
    @required this.businessName,
    @required this.mob,
    @required this.customers,
    @required this.profilePhoto,
    @required this.mitraId,
  });

  @override
  List<Object> get props => [
        name,
        businessName,
        mob,
        customers,
        profilePhoto,
        mitraId,
      ];
}
