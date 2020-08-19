import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/presentation/widgets/custom_button.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';

import '../../../core/constants/measure.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../injection_container.dart';
import '../../widgets/branding_widget.dart';
import '../../widgets/footer_branding_widget.dart';
import 'bloc/phone_screen_bloc.dart';

part 'widgets/mob_input_widget.dart';

class PhoneScreen extends StatefulWidget {
  PhoneScreen({Key key}) : super(key: key);

  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  PhoneScreenBloc _phoneScreenBloc;

  @override
  void initState() {
    super.initState();
    _phoneScreenBloc = sl<PhoneScreenBloc>();
  }

  @override
  void dispose() {
    _phoneScreenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return BlocListener(
      cubit: _phoneScreenBloc,
      listener: (context, state) {
        if (state is SentOtp) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context)
                .pushReplacementNamed(otpRoute, arguments: state.mob);
          });
          return Scaffold();
        }
      },
      child: Scaffold(
        body: Container(
          height: measure.height,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                top: 20,
                child: BrandingWidget(),
              ),
              Center(
                child: BlocProvider(
                  create: (context) => _phoneScreenBloc,
                  child: MobInputWidget(),
                ),
              ),
              Positioned(
                bottom: 0,
                child: FooterBrandingWidget(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
