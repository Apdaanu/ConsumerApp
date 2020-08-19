part of 'suggested_products_bloc.dart';

abstract class SuggestedProductsState extends Equatable {
  const SuggestedProductsState();
}

class SuggestedProductsInitial extends SuggestedProductsState {
  @override
  List<Object> get props => [];
}

class SuggestedProductsLoaded extends SuggestedProductsState {
  final List products;

  SuggestedProductsLoaded(this.products);
  @override
  List<Object> get props => [products];
}
