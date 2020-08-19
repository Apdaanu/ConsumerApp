import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/presentation/widgets/card_shimmer.dart';

import '../../../../core/constants/measure.dart';
import '../../../../core/theme/theme.dart';
import '../../../../domain/entities/categories/recepie.dart';
import '../../../../injection_container.dart';
import '../../../widgets/display_screen.dart';
import '../../../widgets/loader.dart';
import '../../../widgets/regular_text.dart';
import '../../../widgets/top_bar.dart';
import '../../bottom_nav_holder/blocs/referral_bloc/referral_bloc.dart';
import '../../bottom_nav_holder/blocs/user_details_bloc/user_details_bloc.dart';
import 'profile_recepie_bloc/profile_recepie_bloc.dart';
import 'widgets/profile_info_section.dart';
import 'widgets/profile_recepie_card.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  TabController _tabController;
  ReferralBloc _referralBloc;
  ProfileRecepieBloc _profileRecepieBloc;
  UserDetailsBloc _userDetailsBloc;

  @override
  void initState() {
    super.initState();
    _profileRecepieBloc = sl<ProfileRecepieBloc>();
    _userDetailsBloc = context.bloc<UserDetailsBloc>();
    _tabController = new TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _profileRecepieBloc.add(ProfileRecepieToggleCat(_tabController.index));
      });
    });
    _referralBloc = context.bloc<ReferralBloc>();
    _referralBloc.add(ReferralInitEvent());

    _profileRecepieBloc.add(
      ProfileRecepieLoadLiked(_userDetailsBloc.userDetails.userId),
    );

    _profileRecepieBloc.add(
      ProfileRecepieLoadMyRecepies(_userDetailsBloc.userDetails.userId),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);

    final double profileInfoheight =
        100 + measure.width * 0.05 + 40 + measure.topBarHeight + 40;

    Tab tab(String value, int index) {
      return Tab(
        child: BlocBuilder(
          cubit: _profileRecepieBloc,
          builder: (context, state) => RegularText(
            text: value,
            color: _profileRecepieBloc.tabIndex == index
                ? AppTheme.primaryColor
                : AppTheme.black7,
            fontSize: AppTheme.regularTextSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return DisplayScreen(
      body: Column(
        children: <Widget>[
          Container(
            height: measure.screenHeight,
            color: AppTheme.greyF5,
            child: Column(
              children: <Widget>[
                Container(
                  height: profileInfoheight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        blurRadius: 2,
                        offset: Offset(0, 1),
                        color: Color(0x29000000),
                      )
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      CustomTopBar(
                        title: "Profile",
                        lightTheme: true,
                        padding:
                            EdgeInsets.only(left: 10 + measure.width * 0.02),
                        action: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(4),
                              topLeft: Radius.circular(4),
                            ),
                          ),
                          child: BlocBuilder(
                            cubit: _referralBloc,
                            builder: (context, state) => RegularText(
                              text: state is ReferralLoaded
                                  ? AppTheme.currencySymbol +
                                      state.referral.freshOkCredit.toString()
                                  : AppTheme.currencySymbol + '0',
                              color: Colors.white,
                              fontSize: AppTheme.regularTextSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ProfileInfoSection(),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        width: measure.width * 0.8,
                        child: Center(
                          child: TabBar(
                            controller: _tabController,
                            indicatorColor: AppTheme.primaryColor,
                            tabs: <Tab>[
                              tab("Liked", 0),
                              tab("Created", 1),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: measure.screenHeight - profileInfoheight,
                  child: SingleChildScrollView(
                    child: BlocProvider.value(
                      value: _profileRecepieBloc,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20),
                          BlocBuilder(
                            cubit: _profileRecepieBloc,
                            builder: (context, state) =>
                                Column(children: _renderRecepies()),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      failure: false,
      failureCode: 0,
    );
  }

  List<Widget> _renderRecepies() {
    List<Widget> list = List<Widget>();
    if (_profileRecepieBloc.tabIndex == 0) {
      if (_profileRecepieBloc.loadedLiked) {
        for (int i = 0; i < _profileRecepieBloc.likedRecepies.length; i += 2) {
          if (i + 1 == _profileRecepieBloc.likedRecepies.length) {
            list.add(ProfileScreenRecepieRow(
              recepie1: _profileRecepieBloc.likedRecepies[i],
              recepie2: null,
            ));
          } else {
            list.add(ProfileScreenRecepieRow(
              recepie1: _profileRecepieBloc.likedRecepies[i],
              recepie2: _profileRecepieBloc.likedRecepies[i + 1],
            ));
          }
        }
      } else {
        list.addAll(List.generate(6, (index) => CardShimmer(lag: index * 5)));
      }
    } else {
      if (_profileRecepieBloc.loadedMyRecepies) {
        for (int i = 0; i < _profileRecepieBloc.myRecepies.length; i += 2) {
          if (i + 1 == _profileRecepieBloc.myRecepies.length) {
            list.add(ProfileScreenRecepieRow(
              recepie1: _profileRecepieBloc.myRecepies[i],
              recepie2: null,
            ));
          } else {
            list.add(ProfileScreenRecepieRow(
              recepie1: _profileRecepieBloc.myRecepies[i],
              recepie2: _profileRecepieBloc.myRecepies[i + 1],
            ));
          }
        }
      } else {
        list.addAll(List.generate(6, (index) => CardShimmer(lag: index * 5)));
      }
    }
    return list;
  }
}

class ProfileScreenRecepieRow extends StatelessWidget {
  final Recepie recepie1;
  final Recepie recepie2;

  const ProfileScreenRecepieRow({
    Key key,
    @required this.recepie1,
    @required this.recepie2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: measure.width * 0.033,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ProfileRecepieCard(
            recepie: recepie1,
          ),
          recepie2 != null
              ? ProfileRecepieCard(
                  recepie: recepie2,
                )
              : Container(),
        ],
      ),
    );
  }
}
