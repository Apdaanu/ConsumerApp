import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/util/util.dart';
import '../../../../domain/usecases/login/send_otp.dart';

part 'phone_screen_event.dart';
part 'phone_screen_state.dart';

class PhoneScreenBloc extends Bloc<PhoneScreenEvent, PhoneScreenState> {
  final SendOtp sendOtp;

  PhoneScreenBloc({
    @required this.sendOtp,
  }) : super(PhoneScreenInitial());

  TextEditingController mobController = TextEditingController();

  @override
  Stream<PhoneScreenState> mapEventToState(
    PhoneScreenEvent event,
  ) async* {
    if (event is SendOtpEvent) {
      print('[dbg] : hi');
      if (Util.checkCorrectMob(mobController.text)) {
        int mob;
        if (mobController.text.substring(0, 1) == '0') {
          mob = Util.stringToUint(mobController.text.substring(0, 11));
        } else {
          mob = Util.stringToUint(mobController.text);
        }
        print('[sys] : Sending otp to ${mobController.text}');
        yield Loading();
        final failureOrTrue = await sendOtp(Params(mob: mob));
        // yield SentOtp(mob.toString());
        yield failureOrTrue.fold(
          (failure) => ErrorState(failure.code),
          (r) => SentOtp(mobController.text),
        );
      } else {
        yield PhoneError();
      }
    }
  }
}
