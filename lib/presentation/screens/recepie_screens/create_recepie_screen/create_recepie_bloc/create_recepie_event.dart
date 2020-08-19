part of 'create_recepie_bloc.dart';

abstract class CreateRecepieEvent extends Equatable {
  const CreateRecepieEvent();
}

class CreateRecepieNext extends CreateRecepieEvent {
  @override
  List<Object> get props => [];
}

class CreateRecepieBack extends CreateRecepieEvent {
  @override
  List<Object> get props => [];
}

class RefreshEvent extends CreateRecepieEvent {
  @override
  List<Object> get props => [];
}

class CreateRecepieGetDishes extends CreateRecepieEvent {
  @override
  List<Object> get props => [];
}

class CreateRecepieGetCuisines extends CreateRecepieEvent {
  @override
  List<Object> get props => [];
}

class CreateRecepieSelDish extends CreateRecepieEvent {
  final String id;

  CreateRecepieSelDish(this.id);

  @override
  List<Object> get props => [id];
}

class CreateRecepieSelCuisines extends CreateRecepieEvent {
  final String id;

  CreateRecepieSelCuisines(this.id);

  @override
  List<Object> get props => [id];
}

class CreateRecepieAddIngridient extends CreateRecepieEvent {
  final String type;
  final String value;
  final String quantity;

  CreateRecepieAddIngridient({
    this.type,
    this.value,
    this.quantity,
  });

  @override
  List<Object> get props => [
        type,
        value,
        quantity,
      ];
}

class CreateRecepieEditIngridient extends CreateRecepieEvent {
  final String type;
  final String value;
  final String quantity;
  final int index;

  CreateRecepieEditIngridient({
    this.type,
    this.value,
    this.quantity,
    this.index,
  });

  @override
  List<Object> get props => [
        type,
        value,
        quantity,
        index,
      ];
}
