part of 'select_place_bloc.dart';

abstract class SelectPlaceEvent extends Equatable {
  const SelectPlaceEvent();

  @override
  List<Object> get props => [];
}

class SelectPlaceInit extends SelectPlaceEvent {
  final List list;

  SelectPlaceInit(this.list);
}

class SelectPlaceSearch extends SelectPlaceEvent {
  final String search;

  SelectPlaceSearch(this.search);
}
