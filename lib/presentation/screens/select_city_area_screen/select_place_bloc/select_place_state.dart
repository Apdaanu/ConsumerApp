part of 'select_place_bloc.dart';

abstract class SelectPlaceState extends Equatable {
  const SelectPlaceState();

  @override
  List<Object> get props => [];
}

class SelectPlaceInitial extends SelectPlaceState {}

class SelectPlaceLoaded extends SelectPlaceState {}
