import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/presentation/widgets/card_shimmer.dart';

import '../../../../core/constants/measure.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/util/util.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/display_screen.dart';
import '../../../widgets/loader.dart';
import '../../../widgets/regular_text.dart';
import '../../../widgets/top_bar.dart';
import '../../bottom_nav_holder/blocs/referral_bloc/referral_bloc.dart';
import 'referral_detail_card.dart';

class ReferralDetailsScreen extends StatefulWidget {
  @override
  _ReferralDetailsScreenState createState() => _ReferralDetailsScreenState();
}

class _ReferralDetailsScreenState extends State<ReferralDetailsScreen> {
  int menu = 0;

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return DisplayScreen(
      topBar: Container(
        child: CustomTopBar(title: "Refer & Earn"),
      ),
      body: Container(
        color: Colors.white,
        height: measure.bodyHeight,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: 70 + measure.bodyHeight * 0.01,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                      horizontal: 5 + measure.width * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CustomButton(
                        height: 35,
                        width: measure.width * 0.42,
                        onTap: () {
                          setState(() {
                            menu = 0;
                          });
                        },
                        color: menu == 0 ? AppTheme.homeBlue : Colors.grey[300],
                        child: Center(
                          child: RegularText(
                            text: "Consumer",
                            color: menu == 0 ? Colors.white : AppTheme.black5,
                            fontSize: AppTheme.regularTextSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      CustomButton(
                        height: 35,
                        width: measure.width * 0.42,
                        onTap: () {
                          setState(() {
                            menu = 1;
                          });
                        },
                        color: menu == 1 ? AppTheme.homeBlue : Colors.grey[300],
                        child: Center(
                          child: RegularText(
                            text: "Mitra",
                            color: menu == 1 ? Colors.white : AppTheme.black5,
                            fontSize: AppTheme.regularTextSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: measure.bodyHeight * 0.99 - 70,
                  child: SingleChildScrollView(
                    child: BlocBuilder<ReferralBloc, ReferralState>(
                      builder: (context, state) {
                        if (state is ReferralLoaded) {
                          return Column(
                            children: _renderReferredDetails(
                              state.referral.referrals,
                              measure,
                            ),
                          );
                        }
                        return Column(
                          children: List.generate(
                            8,
                            (index) => CardShimmer(lag: index * 10),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: measure.topBarHeight / 2,
              child: Container(
                height: measure.topBarHeight,
                width: measure.width,
                alignment: Alignment.center,
                child: Container(
                  width: measure.width * 0.8,
                  padding: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RegularText(
                        text: "Total Earning",
                        color: Colors.white,
                        fontSize: AppTheme.regularTextSize,
                      ),
                      Container(
                        height: measure.topBarHeight,
                        width: 120,
                        decoration: BoxDecoration(
                          color: AppTheme.lightGreen,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          ),
                        ),
                        child: Center(
                          child: BlocBuilder<ReferralBloc, ReferralState>(
                            builder: (context, state) {
                              if (state is ReferralLoaded) {
                                return RegularText(
                                  text: AppTheme.currencySymbol +
                                      Util.getTotalReferredAmount(
                                          state.referral),
                                  color: Colors.white,
                                  fontSize: AppTheme.regularTextSize,
                                  fontWeight: FontWeight.bold,
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      failure: false,
      failureCode: 0,
    );
  }

  List<Widget> _renderReferredDetails(List referral, Measure measure) {
    List<Widget> list = List<Widget>();

    referral.forEach((element) {
      if (menu == 0 && element.userType == 'customer') {
        list.add(ReferralDetailCard(referredDetails: element));
      }
      if (menu == 1 && element.userType == 'retailer') {
        list.add(ReferralDetailCard(referredDetails: element));
      }
    });

    list.add(SizedBox(height: measure.topBarHeight * 1.5));
    return list;
  }
}
