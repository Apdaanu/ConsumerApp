part of 'phone_screen_bloc.dart';

abstract class PhoneScreenEvent extends Equatable {
  const PhoneScreenEvent();
}

class SendOtpEvent extends PhoneScreenEvent {
  @override
  List<Object> get props => [];
}
