part of 'recepie_list_bloc.dart';

abstract class RecepieListEvent extends Equatable {
  const RecepieListEvent();
}

class RecepieListInit extends RecepieListEvent {
  final String whichPage;
  final String userId;
  final String categoryId;
  final String sectioId;
  final String type;

  RecepieListInit({
    @required this.whichPage,
    @required this.userId,
    @required this.categoryId,
    @required this.sectioId,
    @required this.type,
  });

  @override
  List<Object> get props => [
        whichPage,
        userId,
        categoryId,
        sectioId,
        type,
      ];
}

class RecepieSearchEvent extends RecepieListEvent {
  final String search;

  RecepieSearchEvent(this.search);

  @override
  List<Object> get props => [search];
}

class LikeRecepieEvent extends RecepieListEvent {
  final String recepieId;

  LikeRecepieEvent(this.recepieId);

  @override
  List<Object> get props => [recepieId];
}

class UpdateRecepieLike extends RecepieListEvent {
  final String recepieId;

  UpdateRecepieLike(this.recepieId);

  @override
  List<Object> get props => [recepieId];
}
