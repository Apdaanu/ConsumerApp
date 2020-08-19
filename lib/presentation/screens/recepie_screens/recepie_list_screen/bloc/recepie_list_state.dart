part of 'recepie_list_bloc.dart';

abstract class RecepieListState extends Equatable {
  const RecepieListState();
}

class RecepieListInitial extends RecepieListState {
  @override
  List<Object> get props => [];
}

class RecepieListLoading extends RecepieListState {
  @override
  List<Object> get props => [];
}

class RecepieListLoaded extends RecepieListState {
  final List recepies;

  RecepieListLoaded(this.recepies);

  @override
  List<Object> get props => [recepies];
}
