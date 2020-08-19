import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/core/constants/routes.dart';
import 'package:freshOk/presentation/widgets/custom_button.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../core/constants/measure.dart';
import '../../../core/theme/theme.dart';
import '../../../injection_container.dart';
import '../../widgets/branding_widget.dart';
import '../../widgets/display_screen.dart';
import 'bloc/otp_screen_bloc.dart';

part 'widgets/otp_input_widget.dart';

class OtpScreen extends StatefulWidget {
  final String mob;

  OtpScreen({
    Key key,
    @required this.mob,
  }) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  OtpScreenBloc _otpScreenBloc;

  @override
  void initState() {
    super.initState();
    _otpScreenBloc = sl<OtpScreenBloc>();
    _otpScreenBloc.add(InitEvent(widget.mob));
    print('[dbg] : ${widget.mob}');
  }

  @override
  void dispose() {
    _otpScreenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _otpScreenBloc,
      builder: (context, state) {
        return Scaffold(
          body: DisplayScreen(
            body: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  BrandingWidget(),
                  BlocProvider(
                    create: (context) => _otpScreenBloc,
                    child: OtpInputWidget(),
                  )
                ],
              ),
            ),
            failure: false,
            failureCode: 0,
          ),
        );
      },
    );
  }
}
