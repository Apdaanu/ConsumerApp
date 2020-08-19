part of 'recepie_home_card_bloc.dart';

abstract class RecepieHomeCardState extends Equatable {
  const RecepieHomeCardState();

  @override
  List<Object> get props => [];
}

class RecepieHomeCardInitial extends RecepieHomeCardState {}

class RecepieHomeCardLoaded extends RecepieHomeCardState {}
