import 'package:flutter/foundation.dart';

import '../../../domain/entities/referral/referral.dart';
import 'referred_details_model.dart';

class ReferralModel extends Referral {
  ReferralModel({
    @required String referralCode,
    @required int freshOkCredit,
    @required String mob,
    @required List referrals,
  }) : super(
          referralCode: referralCode,
          freshOkCredit: freshOkCredit,
          mob: mob,
          referrals: referrals,
        );

  factory ReferralModel.fromJson(Map<String, dynamic> json) {
    return ReferralModel(
      referralCode: json['referralCode'],
      freshOkCredit: json['freshOkCredit'],
      mob: json['mob'].toString(),
      referrals: json['referrals']
          .map((item) => ReferredDetailsModel.fromJson(item))
          .toList(),
    );
  }
}
