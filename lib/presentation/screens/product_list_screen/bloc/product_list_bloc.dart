import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../domain/entities/order/local_cart.dart';
import '../../../../domain/usecases/categories/get_products.dart';
import '../../../../domain/usecases/categories/get_products_based_on_search.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final GetProducts getProducts;
  final GetProductsBasesOnSearch getProductsBasesOnSearch;
  ProductListBloc({
    @required this.getProducts,
    @required this.getProductsBasesOnSearch,
  }) : super(ProductListInitial());

  List products;

  @override
  Stream<ProductListState> mapEventToState(
    ProductListEvent event,
  ) async* {
    if (event is ProductListInit) {
      yield ProductListLoading();
      if (event.fromSearch == true) {
        print('[dbg] : from search');
        final failureOrProducts =
            await getProductsBasesOnSearch(event.cateroryId);
        yield* failureOrProducts.fold(
          (failure) async* {
            print('[sys] : failed to fetch products : ${failure.code}');
          },
          (products) async* {
            this.products = products;
            if (products.length > 0) {
              event.cart.cart.forEach((key, value) {
                products[products
                        .indexWhere((element) => element.productId == key)]
                    .quantity = value;
              });
            }
            yield ProductListLoaded(products);
          },
        );
      } else {
        print('[sys] : fetching products...');
        final failureOrProducts = await getProducts(
          GetProductsParams(
            userId: event.userId,
            sectionId: event.sectionId,
            categoryId: event.cateroryId,
            type: event.type,
          ),
        );
        yield* failureOrProducts.fold(
          (failure) async* {
            print('[sys] : failed to fetch products : ${failure.code}');
          },
          (products) async* {
            this.products = products;
            if (products.length > 0) {
              event.cart.cart.forEach((key, value) {
                products[products
                        .indexWhere((element) => element.productId == key)]
                    .quantity = value;
              });
            }
            yield ProductListLoaded(products);
          },
        );
      }
    }

    if (event is ProductSearchEvent) {
      yield ProductListInitial();
      List searchRes = this
          .products
          .where((element) =>
              element.name.toLowerCase().indexOf(event.search.toLowerCase()) !=
              -1)
          .toList();
      yield ProductListLoaded(searchRes);
    }
  }
}
