part of 'recepie_home_bloc.dart';

abstract class RecepieHomeEvent extends Equatable {
  const RecepieHomeEvent();
}

class RecepieHomeInit extends RecepieHomeEvent {
  final String userId;

  RecepieHomeInit(this.userId);

  @override
  List<Object> get props => [userId];
}
