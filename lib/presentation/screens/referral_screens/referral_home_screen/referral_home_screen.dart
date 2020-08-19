import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:freshOk/core/util/util.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/routes.dart';
import '../../bottom_nav_holder/blocs/referral_bloc/referral_bloc.dart';

import '../../../../core/constants/measure.dart';
import '../../../../core/theme/theme.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/display_screen.dart';
import '../../../widgets/regular_text.dart';
import '../../../widgets/top_bar.dart';

const msg = ['invitation for customer', 'invitation for mitra'];
const appName = ["com.freshhaat.consumer", "com.freshhaat.retailer"];
const refLinks = ['referral', 'mitra'];

class ReferralHomeScreen extends StatefulWidget {
  @override
  _ReferralHomeScreenState createState() => _ReferralHomeScreenState();
}

class _ReferralHomeScreenState extends State<ReferralHomeScreen> {
  ReferralBloc _referralBloc;

  @override
  void initState() {
    super.initState();
    _referralBloc = context.bloc<ReferralBloc>();
    _referralBloc.add(ReferralInitEvent());
  }

  int menu = 0;

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return DisplayScreen(
      topBar: Container(
        child: CustomTopBar(
          title: "Refer & Earn",
          action: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(referralDetailRoute);
            },
            child: Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.account_balance_wallet,
                color: Colors.white,
                size: 20 * measure.fontRatio,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        height: measure.bodyHeight,
        width: measure.width,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 5 + measure.width * 0.02),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 5 + measure.screenHeight * 0.01),
                    RegularText(
                      text: "I want to invite",
                      color: Colors.grey[500],
                      fontSize: AppTheme.smallTextSize,
                    ),
                    SizedBox(height: 5 + measure.screenHeight * 0.01),
                    Row(
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
                          color:
                              menu == 0 ? AppTheme.homeBlue : Colors.grey[300],
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
                          color:
                              menu == 1 ? AppTheme.homeBlue : Colors.grey[300],
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
                    SizedBox(height: 5 + measure.screenHeight * 0.01),
                    Container(
                      height: measure.screenHeight * 0.3,
                      child: Image.asset(
                        "assets/images/refer_and_earn.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 10 + measure.screenHeight * 0.02),
                    RegularText(
                      text: "Invite your friends and  earn credit",
                      color: AppTheme.black2,
                      fontSize: AppTheme.headingTextSize,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 5 + measure.screenHeight * 0.01),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: RegularText(
                        text:
                            "Invite friends on freshOk and after they join, both of you will get ${AppTheme.currencySymbol}50 which is redeemable on everything",
                        color: AppTheme.black7,
                        fontSize: AppTheme.regularTextSize,
                        overflow: false,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 10 + measure.screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 5 + measure.screenHeight * 0.01),
                          width: measure.width * 0.5,
                          color: Colors.grey[100],
                          alignment: Alignment.center,
                          child: BlocBuilder(
                            cubit: _referralBloc,
                            builder: (context, state) {
                              if (state is ReferralLoaded) {
                                return RegularText(
                                  text: state.referral.referralCode,
                                  color: AppTheme.black3,
                                  fontSize: AppTheme.headingTextSize,
                                  fontWeight: FontWeight.bold,
                                );
                              }
                              return Shimmer.fromColors(
                                child: RegularText(
                                  text: 'Loading',
                                  color: AppTheme.black3,
                                  fontSize: AppTheme.headingTextSize,
                                  fontWeight: FontWeight.bold,
                                ),
                                baseColor: Colors.grey[300],
                                highlightColor: Colors.white,
                                period: Duration(milliseconds: 800),
                              );
                            },
                          ),
                        ),
                        BlocBuilder(
                          cubit: _referralBloc,
                          builder: (context, state) {
                            return Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    if (state is ReferralLoaded)
                                      _shareLink(
                                        msg[menu],
                                        state.referral.referralCode,
                                        0,
                                      );
                                  },
                                  child: Image.asset(
                                    "assets/images/wa-logo.png",
                                    height: 15 + measure.screenHeight * 0.03,
                                  ),
                                ),
                                SizedBox(width: 15),
                                GestureDetector(
                                  onTap: () {
                                    if (state is ReferralLoaded)
                                      _shareLink(
                                        msg[menu],
                                        state.referral.referralCode,
                                        1,
                                      );
                                  },
                                  child: Container(
                                    height: 15 + measure.screenHeight * 0.025,
                                    width: 15 + measure.screenHeight * 0.025,
                                    decoration: BoxDecoration(
                                      color: AppTheme.cartRed,
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                    child: Icon(
                                      Icons.share,
                                      color: Colors.white,
                                      size: 18 * measure.fontRatio,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 5 + measure.screenHeight * 0.01),
                    SizedBox(height: measure.topBarHeight)
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: measure.topBarHeight,
                width: measure.width,
                padding: EdgeInsets.only(left: 20 + measure.width * 0.04),
                color: AppTheme.primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RegularText(
                      text: "Total Earning",
                      color: Colors.white,
                      fontSize: AppTheme.regularTextSize,
                    ),
                    CustomButton(
                      height: measure.topBarHeight,
                      width: 150,
                      color: AppTheme.lightGreen,
                      onTap: () {
                        Navigator.of(context).pushNamed(referralDetailRoute);
                      },
                      child: Center(
                        child: BlocBuilder(
                          cubit: _referralBloc,
                          builder: (context, state) {
                            if (state is ReferralLoaded) {
                              return RegularText(
                                text: AppTheme.currencySymbol +
                                    Util.getTotalReferredAmount(state.referral),
                                color: Colors.white,
                                fontSize: AppTheme.regularTextSize,
                                fontWeight: FontWeight.bold,
                              );
                            }
                            return Shimmer.fromColors(
                              child: RegularText(
                                text: 'Loading',
                                color: AppTheme.black3,
                                fontSize: AppTheme.headingTextSize,
                                fontWeight: FontWeight.bold,
                              ),
                              baseColor: Colors.white,
                              highlightColor: Colors.grey[300],
                              period: Duration(milliseconds: 800),
                            );
                          },
                        ),
                      ),
                    )
                  ],
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

  void _shareLink(String msg, String refCode, int to) async {
    final ShortDynamicLink link = await _createDynamicLink(refCode);
    final String message = msg + ' ' + link.shortUrl.toString();
    if (to == 0)
      FlutterShareMe().shareToWhatsApp(msg: message);
    else if (to == 1) FlutterShareMe().shareToSystem(msg: message);
  }

  Future<ShortDynamicLink> _createDynamicLink(String refCode) async {
    print('[dbg] : https://freshok.in/${refLinks[menu]}?ref=$refCode');
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://freshok.page.link',
      link: Uri.parse('https://freshok.in/${refLinks[menu]}?ref=$refCode'),
      androidParameters: AndroidParameters(
        packageName: appName[menu],
        minimumVersion: 0,
      ),
    );

    final ShortDynamicLink dynamicLink = await parameters.buildShortLink();
    print('[dbg] : ${dynamicLink.shortUrl}');
    return dynamicLink;
  }
}
