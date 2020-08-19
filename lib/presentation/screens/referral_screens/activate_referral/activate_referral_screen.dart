import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/presentation/screens/registration_screen.dart/bloc/registration_screen_bloc.dart';
import 'package:freshOk/presentation/widgets/custom_button.dart';
import 'package:freshOk/presentation/widgets/display_screen.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';

class ActivateReferralScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RegistrationScreenBloc registrationScreenBloc =
        context.bloc<RegistrationScreenBloc>();
    Measure measure = MeasureImpl(context);
    return DisplayScreen(
      body: Center(
        child: Container(
          width: measure.width * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.3,
                    color: Color(0xff707070),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextField(
                  textInputAction: TextInputAction.done,
                  controller: registrationScreenBloc.referralController,
                  // style: style,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: "Referral Code",
                    border: InputBorder.none,
                  ),
                  textAlign: TextAlign.center,
                  style: AppTheme.style.copyWith(
                    fontSize: AppTheme.regularTextSize * measure.fontRatio,
                    color: AppTheme.black2,
                  ),
                ),
              ),
              SizedBox(height: 30),
              CustomButton(
                height: 40 + measure.screenHeight * 0.01,
                width: null,
                onTap: () {
                  registrationScreenBloc.add(RegisterUserDoneReferral());
                },
                color: AppTheme.primaryColor,
                child: Center(
                  child: RegularText(
                    text: 'APPLY',
                    color: Colors.white,
                    fontSize: AppTheme.regularTextSize,
                  ),
                ),
              ),
              SizedBox(height: 15),
              FlatButton(
                  onPressed: () {
                    registrationScreenBloc.add(RegisterUserDoneReferral());
                  },
                  child: RegularText(
                    text: 'SKIP',
                    color: AppTheme.primaryColor,
                    fontSize: AppTheme.smallTextSize,
                  )),
            ],
          ),
        ),
      ),
      failure: false,
      failureCode: 0,
    );
  }
}
