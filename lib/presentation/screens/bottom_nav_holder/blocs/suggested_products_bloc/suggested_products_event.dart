part of 'suggested_products_bloc.dart';

abstract class SuggestedProductsEvent extends Equatable {
  const SuggestedProductsEvent();
}

class SuggestedProductsInitEvent extends SuggestedProductsEvent {
  final String userId;

  SuggestedProductsInitEvent(this.userId);
  @override
  List<Object> get props => [userId];
}

class SuggestedProductInitCart extends SuggestedProductsEvent {
  final LocalCart cart;

  SuggestedProductInitCart(this.cart);

  @override
  List<Object> get props => [cart];
}

class UpdateProductQty extends SuggestedProductsEvent {
  final double qty;
  final Product product;

  UpdateProductQty({
    this.qty,
    this.product,
  });

  @override
  List<Object> get props => [qty, product];
}
