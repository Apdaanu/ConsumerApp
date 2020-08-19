import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/constants/routes.dart';
import 'package:freshOk/core/util/util.dart';
import 'package:freshOk/domain/usecases/login/send_otp.dart' as so;
import 'package:freshOk/domain/usecases/login/verify_otp.dart' as vo;
import 'package:freshOk/main.dart';

part 'otp_screen_event.dart';
part 'otp_screen_state.dart';

class OtpScreenBloc extends Bloc<OtpScreenEvent, OtpScreenState> {
  final vo.VerifyOtp verifyOtp;
  final so.SendOtp sendOtp;

  OtpScreenBloc({@required this.verifyOtp, @required this.sendOtp})
      : assert(verifyOtp != null),
        assert(sendOtp != null),
        super(null);

  String mob;
  bool posting = false;
  bool err = false;
  String errMsg;

  @override
  OtpScreenState get initialState => OtpScreenInitial();

  @override
  Stream<OtpScreenState> mapEventToState(
    OtpScreenEvent event,
  ) async* {
    if (event is InitEvent) {
      mob = event.mob;
    }

    if (event is VerifyOtpEvent) {
      if (!this.posting) {
        yield OtpScreenInitial();
        this.posting = true;
        yield OtpScreenLoaded();
        final int mobInt = Util.stringToUint(mob);
        print('[dbg] : $mobInt');
        final int otp = Util.stringToUint(event.otp);
        final failureOrBasicUser = await verifyOtp(
          vo.Params(
            mob: mobInt,
            otp: otp,
            status: 'customer',
          ),
        );
        yield* failureOrBasicUser.fold(
          (failure) async* {
            switch (failure.code) {
              case 400:
                yield OtpScreenInitial();
                this.posting = false;
                this.err = true;
                this.errMsg = 'OTP verification failed, please try again';
                yield OtpScreenLoaded();
                print('[err] : Verification failed, wrong otp');
                break;
              case 100:
                yield OtpScreenInitial();
                this.posting = false;
                this.err = true;
                this.errMsg = 'We\'re having trouble reaching our servers';
                yield OtpScreenLoaded();
                print('[sys] : Server cannot be reached');
                break;
              default:
            }
          },
          (basicUser) async* {
            print('[sys] : otp verified');
            if (basicUser.newUser) {
              navigatorKey.currentState.pushNamed(registerRoute);
            } else {
              navigatorKey.currentState.pushNamed(homeRoute);
            }
          },
        );
      }
    }

    if (event is ResendOtpEvent) {
      this.err = false;
      print('[sys] : Resending otp to $mob');
      final int mobInt = Util.stringToUint(mob);
      final failureOrTrue = await sendOtp(so.Params(mob: mobInt));
      yield* failureOrTrue.fold(
        (failure) async* {
          yield OtpScreenInitial();
          this.posting = false;
          this.err = true;
          this.errMsg = 'We failed to send OTP again';
          yield OtpScreenLoaded();
        },
        (r) async* {
          yield OtpScreenLoaded();
        },
      );
    }
  }
}
