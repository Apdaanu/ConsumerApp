part of 'home_search_bloc.dart';

abstract class HomeSearchState extends Equatable {
  const HomeSearchState();

  @override
  List<Object> get props => [];
}

class HomeSearchInitial extends HomeSearchState {}

class HomeSearchLoading extends HomeSearchState {}

class HomeSearchLoaded extends HomeSearchState {}
