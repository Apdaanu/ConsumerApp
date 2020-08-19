part of 'registration_screen_bloc.dart';

abstract class RegistrationScreenState extends Equatable {
  const RegistrationScreenState();
}

class RegistrationScreenInitial extends RegistrationScreenState {
  @override
  List<Object> get props => [];
}

class RegisterUserLoading extends RegistrationScreenState {
  @override
  List<Object> get props => [];
}

class RegisterUserLoaded extends RegistrationScreenState {
  final List<dynamic> places;

  RegisterUserLoaded(this.places);

  @override
  List<Object> get props => [places];
}

class RegisterUserFilledReferral extends RegistrationScreenState {
  @override
  List<Object> get props => [];
}

class RegisterUserCitySelected extends RegistrationScreenState {
  final List<dynamic> places;

  RegisterUserCitySelected(this.places);

  @override
  List<Object> get props => [places];
}

class RegisterUserGoBack extends RegistrationScreenState {
  @override
  List<Object> get props => [];
}

class UserRegisteredState extends RegistrationScreenState {
  @override
  List<Object> get props => [];
}
