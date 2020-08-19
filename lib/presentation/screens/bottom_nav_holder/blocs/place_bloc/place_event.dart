part of 'place_bloc.dart';

abstract class PlaceEvent extends Equatable {
  const PlaceEvent();
}

class PlaceInitEvent extends PlaceEvent {
  final next;

  PlaceInitEvent({this.next});

  @override
  List<Object> get props => [];
}
