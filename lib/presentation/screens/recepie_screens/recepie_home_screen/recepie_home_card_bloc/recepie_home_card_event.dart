part of 'recepie_home_card_bloc.dart';

abstract class RecepieHomeCardEvent extends Equatable {
  const RecepieHomeCardEvent();
}

class CardBlocInit extends RecepieHomeCardEvent {
  final SubCategory recepie;
  final String userId;

  CardBlocInit(
    this.recepie,
    this.userId,
  );

  @override
  List<Object> get props => [
        recepie,
        userId,
      ];
}

class CardLikeRecepie extends RecepieHomeCardEvent {
  @override
  List<Object> get props => [];
}

class UpdateCardLikeRecepie extends RecepieHomeCardEvent {
  UpdateCardLikeRecepie();

  @override
  List<Object> get props => [];
}
