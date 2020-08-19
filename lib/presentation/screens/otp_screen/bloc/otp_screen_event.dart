part of 'otp_screen_bloc.dart';

abstract class OtpScreenEvent extends Equatable {
  const OtpScreenEvent();
}

class VerifyOtpEvent extends OtpScreenEvent {
  final String otp;

  VerifyOtpEvent({
    @required this.otp,
  });
  @override
  List<Object> get props => [otp];
}

class InitEvent extends OtpScreenEvent {
  final String mob;

  InitEvent(this.mob);

  @override
  List<Object> get props => [mob];
}

class ResendOtpEvent extends OtpScreenEvent {
  @override
  List<Object> get props => [];
}
