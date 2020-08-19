part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();
}

class CartInitial extends CartState {
  @override
  List<Object> get props => [];
}

class CartLoaded extends CartState {
  final LocalCart cart;

  CartLoaded(this.cart);

  @override
  List<Object> get props => [];
}
