part of 'home_search_bloc.dart';

abstract class HomeSearchEvent extends Equatable {
  const HomeSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchProductsEvent extends HomeSearchEvent {
  final String search;

  SearchProductsEvent(this.search);
}

class HomeSearchInit extends HomeSearchEvent {
  final String type;

  HomeSearchInit(this.type);
}
