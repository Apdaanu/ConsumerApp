part of 'phone_screen_bloc.dart';

abstract class PhoneScreenState extends Equatable {
  const PhoneScreenState();
}

class PhoneScreenInitial extends PhoneScreenState {
  @override
  List<Object> get props => [];
}

class Loading extends PhoneScreenState {
  @override
  List<Object> get props => [];
}

class SentOtp extends PhoneScreenState {
  final String mob;

  SentOtp(this.mob);

  @override
  List<Object> get props => [mob];
}

class PhoneError extends PhoneScreenState {
  @override
  List<Object> get props => [];
}

class ErrorState extends PhoneScreenState {
  final int errCode;

  ErrorState(this.errCode);

  @override
  List<Object> get props => [errCode];
}
