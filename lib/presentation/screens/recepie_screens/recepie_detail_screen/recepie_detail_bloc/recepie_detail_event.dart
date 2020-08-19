part of 'recepie_detail_bloc.dart';

abstract class RecepieDetailEvent extends Equatable {
  const RecepieDetailEvent();
}

class RecepieDetailsInit extends RecepieDetailEvent {
  final String recepieId;
  final String userId;
  final LocalCart cart;

  RecepieDetailsInit({
    this.recepieId,
    this.cart,
    this.userId,
  });

  @override
  List<Object> get props => [
        recepieId,
        cart,
        userId,
      ];
}

class RecepieDetailSetQty extends RecepieDetailEvent {
  final Ingredient ingredient;
  final double qty;

  RecepieDetailSetQty({
    @required this.ingredient,
    @required this.qty,
  });

  @override
  List<Object> get props => [
        ingredient,
        qty,
      ];
}

class RecepieDetailLikeEvent extends RecepieDetailEvent {
  @override
  List<Object> get props => [];
}
