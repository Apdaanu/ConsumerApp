part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
}

class CartInitEvent extends CartEvent {
  @override
  List<Object> get props => [];
}

class CartIncEvent extends CartEvent {
  final Product product;
  final next;

  CartIncEvent(this.product, this.next);

  @override
  List<Object> get props => [product, next];
}

class CartDecEvent extends CartEvent {
  final Product product;
  final next;

  CartDecEvent(this.product, this.next);

  @override
  List<Object> get props => [product];
}

class CartRemEvent extends CartEvent {
  final Product product;
  final next;

  CartRemEvent(this.product, this.next);

  @override
  List<Object> get props => [product];
}

class CartClearEvent extends CartEvent {
  @override
  List<Object> get props => [];
}
