part of 'registration_screen_bloc.dart';

abstract class RegistrationScreenEvent extends Equatable {
  const RegistrationScreenEvent();
}

class RegisterUserInitEvent extends RegistrationScreenEvent {
  @override
  List<Object> get props => [];
}

class RegisterUserDoneReferral extends RegistrationScreenEvent {
  @override
  List<Object> get props => [];
}

class RegisterUserSelectCityEvent extends RegistrationScreenEvent {
  final String cityId;

  RegisterUserSelectCityEvent(this.cityId);

  @override
  List<Object> get props => [cityId];
}

class RegisterUserGoBackEvent extends RegistrationScreenEvent {
  @override
  List<Object> get props => [];
}

class RegisterUserSelectAreaEvent extends RegistrationScreenEvent {
  final String areaId;

  RegisterUserSelectAreaEvent(this.areaId);

  @override
  List<Object> get props => [areaId];
}
