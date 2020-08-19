part of 'place_bloc.dart';

abstract class PlaceState extends Equatable {
  const PlaceState();
}

class PlaceInitial extends PlaceState {
  @override
  List<Object> get props => [];
}

class PlaceLoading extends PlaceState {
  @override
  List<Object> get props => [];
}

class PlaceLoaded extends PlaceState {
  final List places;

  PlaceLoaded(this.places);

  @override
  List<Object> get props => [];
}
