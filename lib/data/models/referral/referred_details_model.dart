import 'package:flutter/foundation.dart';

import '../../../domain/entities/referral/referred_details.dart';

class ReferredDetailsModel extends ReferredDetails {
  ReferredDetailsModel({
    @required String name,
    @required String profilePhoto,
    @required String mob,
    @required int invitationDate,
    @required int referralCount,
    @required int freshOkCredit,
    @required String userType,
  }) : super(
          name: name,
          profilePhoto: profilePhoto,
          mob: mob,
          invitationDate: invitationDate,
          referralCount: referralCount,
          freshOkCredit: freshOkCredit,
          userType: userType,
        );

  factory ReferredDetailsModel.fromJson(Map<String, dynamic> json) {
    return ReferredDetailsModel(
      name: json['name'],
      profilePhoto: json['profilePhoto'],
      mob: json['mob'].toString(),
      invitationDate: json['invitationDate'],
      referralCount: json['referralCount'],
      freshOkCredit: json['freshOkCredit'],
      userType: json['userType'],
    );
  }
}
