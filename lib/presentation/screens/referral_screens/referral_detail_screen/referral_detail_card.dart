import 'package:flutter/material.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/core/util/util.dart';
import 'package:freshOk/domain/entities/referral/referred_details.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';

class ReferralDetailCard extends StatelessWidget {
  final ReferredDetails referredDetails;
  const ReferralDetailCard({
    Key key,
    @required this.referredDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 5 + measure.width * 0.01,
        vertical: 10 + measure.screenHeight * 0.01,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 0.3,
            color: Color(0xffc7c7c7),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 40 + measure.width * 0.02,
                height: 40 + measure.width * 0.02,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Image.network(
                  referredDetails.profilePhoto,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RegularText(
                    text: referredDetails.name,
                    color: AppTheme.black3,
                    fontSize: AppTheme.regularTextSize,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      RegularText(
                        text: "Referred",
                        color: AppTheme.black2,
                        fontSize: AppTheme.regularTextSize,
                        fontStyle: FontStyle.italic,
                      ),
                      SizedBox(width: 10),
                      RegularText(
                        text: referredDetails.referralCount.toString(),
                        color: AppTheme.referGreen,
                        fontSize: AppTheme.regularTextSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  )
                ],
              ),
              Expanded(child: Container()),
              Column(
                children: <Widget>[
                  RegularText(
                    text:
                        "${AppTheme.currencySymbol}${referredDetails.freshOkCredit} Credits",
                    color: AppTheme.black3,
                    fontSize: AppTheme.regularTextSize,
                    fontWeight: FontWeight.bold,
                  ),
                  RegularText(
                    text: "Earned",
                    color: AppTheme.referGreen,
                    fontSize: AppTheme.regularTextSize,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 15),
          RegularText(
            text: "Invitation: " +
                Util.getDateFromTimeStamp(
                    referredDetails.invitationDate)['date'],
            color: AppTheme.black7,
            fontSize: AppTheme.regularTextSize,
          ),
        ],
      ),
    );
  }
}
