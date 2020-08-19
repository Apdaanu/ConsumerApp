import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/constants/icons.dart';
import '../../../../../core/constants/measure.dart';
import '../../../../../core/constants/routes.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../../injection_container.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/regular_text.dart';
import '../../blocs/drawer_bloc/drawer_bloc.dart';
import '../../blocs/referral_bloc/referral_bloc.dart';
import '../../blocs/user_details_bloc/user_details_bloc.dart';

class DrawerContents extends StatefulWidget {
  @override
  _DrawerContentsState createState() => _DrawerContentsState();
}

class _DrawerContentsState extends State<DrawerContents> {
  UserDetailsBloc _userDetailsBloc;
  DrawerBloc _drawerBloc;
  ReferralBloc _referralBloc;

  @override
  void initState() {
    super.initState();
    _userDetailsBloc = context.bloc<UserDetailsBloc>();
    _drawerBloc = sl<DrawerBloc>();
    _referralBloc = context.bloc<ReferralBloc>();

    _referralBloc.add(ReferralInitEvent());
  }

  @override
  void dispose() {
    _drawerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, profileScreenRoute);
                },
                child: Container(
                  alignment: Alignment.center,
                  color: AppTheme.greyFB,
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 10 + measure.width * 0.02),
                      CircleAvatar(
                        radius: 28 * measure.fontRatio,
                        backgroundImage: Image.network(
                                _userDetailsBloc.userDetails.profilePhoto)
                            .image,
                        backgroundColor: Colors.transparent,
                      ),
                      SizedBox(width: 10 + measure.width * 0.01),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RegularText(
                            text: _userDetailsBloc.userDetails.name,
                            color: AppTheme.black2,
                            fontSize: AppTheme.regularTextSize,
                            fontWeight: FontWeight.w600,
                          ),
                          RegularText(
                            text: _userDetailsBloc.basicUser.mob.toString(),
                            color: AppTheme.black7,
                            fontSize: AppTheme.regularTextSize,
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        height: 60 + measure.screenHeight * 0.07,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              blurRadius: 1,
                              offset: Offset(0, 0),
                              color: Color(0x29000000),
                            ),
                          ],
                        ),
                        child: Icon(Icons.chevron_right),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                color: AppTheme.primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DrawerMenuItem(
                      icon: SvgPicture.asset(
                        walletIcon,
                        color: Colors.white,
                        height: 16 * measure.fontRatio,
                      ),
                      title: "freshOk Credits",
                      padding: 1,
                      textColor: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: BlocBuilder(
                        cubit: _referralBloc,
                        builder: (context, state) => RegularText(
                          text: AppTheme.currencySymbol +
                              (state is ReferralLoaded
                                  ? _referralBloc.referral.freshOkCredit
                                      .toString()
                                  : '60'),
                          color: Colors.white,
                          fontSize: AppTheme.regularTextSize,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              DrawerMenuItem(
                icon: SvgPicture.asset(
                  freshOkIconSvg,
                  color: AppTheme.black5,
                  height: 16 * measure.fontRatio,
                ),
                title: "Home",
              ),
              DrawerMenuItem(
                onTap: () {
                  Navigator.pushNamed(context, selectMitraRoute);
                },
                icon: Icon(
                  Icons.record_voice_over,
                  color: AppTheme.black5,
                  size: 15 * measure.fontRatio,
                ),
                title: "Fresh Mitra",
                padding: 3,
              ),
              DrawerMenuItem(
                onTap: () {
                  Navigator.pushNamed(context, customerSupportRoute);
                },
                icon: SvgPicture.asset(
                  supportSvg,
                  color: AppTheme.black5,
                  height: 16 * measure.fontRatio,
                ),
                title: "Customer Support",
              ),
              DrawerMenuItem(
                onTap: () {
                  launch('market://details?id=com.freshhaat.consumer');
                },
                icon: Icon(
                  Icons.star,
                  color: AppTheme.black5,
                  size: 15 * measure.fontRatio,
                ),
                title: "Rate Us",
                padding: 1,
              ),
              DrawerMenuItem(
                onTap: () {
                  Navigator.pushNamed(context, aboutRoute);
                },
                icon: SvgPicture.asset(
                  freshOkCircle,
                  color: AppTheme.black2,
                  height: 16 * measure.fontRatio,
                ),
                title: "About Us",
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: measure.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  blurRadius: 1,
                  offset: Offset(0, 0),
                  color: Color(0x29000000),
                ),
              ],
            ),
            child: DrawerMenuItem(
              icon: Icon(
                Icons.power_settings_new,
                color: Colors.grey,
                size: 15 * measure.fontRatio,
              ),
              title: "Logout",
              textColor: Colors.grey,
              onTap: () {
                _drawerBloc.add(LogoutEvent());
              },
            ),
          ),
        ),
      ],
    );
  }
}

class DrawerMenuItem extends StatelessWidget {
  final String title;
  final Widget icon;
  final onTap;
  final Color textColor;
  final double padding;

  const DrawerMenuItem({
    Key key,
    @required this.title,
    @required this.icon,
    this.onTap,
    this.textColor,
    this.padding = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return CustomButton(
      color: Colors.transparent,
      height: null,
      onTap: () {
        Navigator.pop(context);
        if (onTap != null) {
          onTap();
        }
      },
      width: null,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10 + measure.width * 0.02,
          vertical: 10 + measure.screenHeight * 0.01,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: 30 + measure.width * 0.02,
              padding: EdgeInsets.only(left: padding),
              alignment: Alignment.centerLeft,
              child: icon,
            ),
            RegularText(
              text: title,
              color: textColor ?? AppTheme.black2,
              fontSize: AppTheme.regularTextSize,
            ),
          ],
        ),
      ),
    );
  }
}
