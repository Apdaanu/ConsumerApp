import 'package:flutter/foundation.dart';
import 'package:freshOk/domain/entities/base_model.dart';

class ReferredDetails extends BaseModel {
  final String name;
  final String profilePhoto;
  final String mob;
  final int invitationDate;
  final int referralCount;
  final int freshOkCredit;
  final String userType;

  ReferredDetails({
    @required this.name,
    @required this.profilePhoto,
    @required this.mob,
    @required this.invitationDate,
    @required this.referralCount,
    @required this.freshOkCredit,
    @required this.userType,
  });

  @override
  List<Object> get props => [
        name,
        profilePhoto,
        mob,
        invitationDate,
        referralCount,
        freshOkCredit,
        userType,
      ];
}
