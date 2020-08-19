part of 'profile_recepie_bloc.dart';

abstract class ProfileRecepieEvent extends Equatable {
  const ProfileRecepieEvent();
}

class ProfileRecepieLoadMyRecepies extends ProfileRecepieEvent {
  final String userId;

  ProfileRecepieLoadMyRecepies(this.userId);

  @override
  List<Object> get props => [userId];
}

class ProfileRecepieLoadLiked extends ProfileRecepieEvent {
  final String userId;

  ProfileRecepieLoadLiked(this.userId);

  @override
  List<Object> get props => [userId];
}

class ProfileRecepieToggleCat extends ProfileRecepieEvent {
  final int index;

  ProfileRecepieToggleCat(this.index);

  @override
  List<Object> get props => [index];
}

class ProfileRecepieLike extends ProfileRecepieEvent {
  final String recepieId;

  ProfileRecepieLike(this.recepieId);

  @override
  List<Object> get props => [recepieId];
}

class ProfileRecepieLikeAction extends ProfileRecepieEvent {
  final String recepieId;

  ProfileRecepieLikeAction(this.recepieId);

  @override
  List<Object> get props => [recepieId];
}
