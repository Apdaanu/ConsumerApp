part of 'product_list_bloc.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();
}

class ProductListInit extends ProductListEvent {
  final String userId;
  final String sectionId;
  final String cateroryId;
  final String type;
  final LocalCart cart;
  final bool fromSearch;

  ProductListInit({
    @required this.userId,
    @required this.sectionId,
    @required this.cateroryId,
    @required this.type,
    @required this.cart,
    @required this.fromSearch,
  });

  @override
  List<Object> get props => [
        userId,
        sectionId,
        cateroryId,
        type,
        cart,
        fromSearch,
      ];
}

class ProductSearchEvent extends ProductListEvent {
  final String search;

  ProductSearchEvent(this.search);

  @override
  List<Object> get props => [search];
}
