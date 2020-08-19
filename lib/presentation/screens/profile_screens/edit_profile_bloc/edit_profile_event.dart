part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();
}

class EditProfileInitEvent extends EditProfileEvent {
  final UserDetails userDetails;
  final List places;

  EditProfileInitEvent({
    @required this.userDetails,
    @required this.places,
  });

  @override
  List<Object> get props => [
        userDetails,
        places,
      ];
}

class RegisterChange extends EditProfileEvent {
  @override
  List<Object> get props => [];
}
