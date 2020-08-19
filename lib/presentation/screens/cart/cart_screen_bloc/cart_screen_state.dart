part of 'cart_screen_bloc.dart';

abstract class CartScreenState extends Equatable {
  const CartScreenState();
}

class CartScreenInitial extends CartScreenState {
  @override
  List<Object> get props => [];
}

class CartScreenLoaded extends CartScreenState {
  final Cart cart;

  CartScreenLoaded(
    this.cart,
  );

  @override
  List<Object> get props => [cart];
}
