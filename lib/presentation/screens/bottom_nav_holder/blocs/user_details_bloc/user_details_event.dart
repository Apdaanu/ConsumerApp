part of 'user_details_bloc.dart';

abstract class UserDetailsEvent extends Equatable {
  const UserDetailsEvent();
}

class InitUserDetailsEvent extends UserDetailsEvent {
  final next;

  InitUserDetailsEvent(this.next);

  @override
  List<Object> get props => [next];
}

class UserDetailsEditEvent extends UserDetailsEvent {
  final String address;
  final String cityId;
  final String areaId;
  final String landmark;
  final String pin;
  final String name;
  final next;

  UserDetailsEditEvent({
    @required this.address,
    @required this.cityId,
    @required this.areaId,
    @required this.landmark,
    @required this.pin,
    @required this.name,
    this.next,
  });

  @override
  List<Object> get props => [
        address,
        cityId,
        areaId,
        landmark,
        pin,
        name,
        next,
      ];
}

class UserDetailsChangeMitra extends UserDetailsEvent {
  final String mitraId;

  UserDetailsChangeMitra(this.mitraId);

  @override
  List<Object> get props => [mitraId];
}

class UserDetailsChangePhoto extends UserDetailsEvent {
  final File file;

  UserDetailsChangePhoto(this.file);

  @override
  List<Object> get props => [file];
}
