import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/core/constants/routes.dart';
import 'package:freshOk/injection_container.dart';
import 'package:freshOk/presentation/screens/referral_screens/activate_referral/activate_referral_screen.dart';
import 'package:freshOk/presentation/screens/registration_screen.dart/bloc/registration_screen_bloc.dart';
import 'package:freshOk/presentation/screens/select_city_area_screen/select_city_area.dart';

import '../../../core/constants/measure.dart';

// part 'widgets/registration_screen_body_widget.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({Key key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  RegistrationScreenBloc _registrationScreenBloc;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _registrationScreenBloc = sl<RegistrationScreenBloc>();
    _pageController = PageController();

    _registrationScreenBloc.add(RegisterUserInitEvent());
  }

  @override
  void dispose() {
    _registrationScreenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return BlocBuilder(
      cubit: _registrationScreenBloc,
      builder: (context, state) {
        if (state is UserRegisteredState) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushNamed(homeRoute, arguments: 0);
          });
          return Container();
        }

        if (state is RegisterUserFilledReferral) {
          _pageController.animateToPage(
            1,
            duration: Duration(milliseconds: 100),
            curve: Curves.easeIn,
          );
        }

        if (state is RegisterUserCitySelected) {
          _pageController.animateToPage(
            2,
            duration: Duration(milliseconds: 100),
            curve: Curves.easeIn,
          );
        }

        if (state is RegisterUserGoBack) {
          _pageController.animateToPage(
            _pageController.page.toInt() - 1,
            duration: Duration(milliseconds: 100),
            curve: Curves.easeIn,
          );
        }

        return PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            BlocProvider.value(
              value: _registrationScreenBloc,
              child: ActivateReferralScreen(),
            ),
            SelectCityAreaScreen(
              list: state is RegisterUserLoaded ? state.places : [],
              title: "Select City",
              ddFxn: (cityId) {
                _registrationScreenBloc.add(
                  RegisterUserSelectCityEvent(cityId),
                );
              },
              backAlt: () {
                _registrationScreenBloc.add(RegisterUserGoBackEvent());
              },
              loading: state is RegisterUserLoading ? true : false,
            ),
            SelectCityAreaScreen(
              list: state is RegisterUserCitySelected ? state.places : [],
              title: "Select Area",
              ddFxn: (areaId) {
                _registrationScreenBloc
                    .add(RegisterUserSelectAreaEvent(areaId));
              },
              backAlt: () {
                _registrationScreenBloc.add(RegisterUserGoBackEvent());
              },
              loading: state is RegisterUserLoading ? true : false,
            ),
          ],
        );
        // DisplayScreen(
        //   body: Container(
        //     height: measure.screenHeight,
        //     child: SingleChildScrollView(
        //       child: Column(
        //         children: <Widget>[
        //           BrandingWidget(),
        //           BlocProvider(
        //             create: (context) => _registrationScreenBloc,
        //             child: RegistrationScreenBodyWidget(),
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        //   failure: false,
        //   failureCode: 0,
        // );
      },
    );
  }
}
