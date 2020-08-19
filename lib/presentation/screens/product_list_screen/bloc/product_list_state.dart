part of 'product_list_bloc.dart';

abstract class ProductListState extends Equatable {
  const ProductListState();
}

class ProductListInitial extends ProductListState {
  @override
  List<Object> get props => [];
}

class ProductListLoading extends ProductListState {
  @override
  List<Object> get props => [];
}

class ProductListLoaded extends ProductListState {
  final List products;

  ProductListLoaded(this.products);

  @override
  List<Object> get props => [products];
}
