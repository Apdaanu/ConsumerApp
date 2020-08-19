part of 'user_details_bloc.dart';

abstract class UserDetailsState extends Equatable {
  const UserDetailsState();
}

class UserDetailsInitial extends UserDetailsState {
  @override
  List<Object> get props => [];
}

class LoadingUserState extends UserDetailsState {
  @override
  List<Object> get props => [];
}

class LoadedUserState extends UserDetailsState {
  final UserDetails userDetails;

  LoadedUserState(this.userDetails);

  @override
  List<Object> get props => [userDetails];
}
