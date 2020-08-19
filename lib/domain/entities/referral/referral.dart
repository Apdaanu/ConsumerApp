import 'package:flutter/cupertino.dart';
import 'package:freshOk/domain/entities/base_model.dart';

class Referral extends BaseModel {
  final String referralCode;
  final int freshOkCredit;
  final String mob;
  final List referrals;

  Referral({
    @required this.referralCode,
    @required this.freshOkCredit,
    @required this.mob,
    @required this.referrals,
  });

  @override
  List<Object> get props => [
        referralCode,
        freshOkCredit,
        mob,
        referrals,
      ];
}
