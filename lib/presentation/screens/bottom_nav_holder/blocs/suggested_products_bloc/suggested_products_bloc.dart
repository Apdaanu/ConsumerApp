import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/domain/entities/categories/product.dart';
import 'package:freshOk/domain/entities/order/local_cart.dart';
import 'package:freshOk/domain/usecases/categories/get_suggested.dart';

part 'suggested_products_event.dart';
part 'suggested_products_state.dart';

class SuggestedProductsBloc
    extends Bloc<SuggestedProductsEvent, SuggestedProductsState> {
  final GetSuggested getSuggested;

  SuggestedProductsBloc(this.getSuggested) : super(SuggestedProductsInitial());

  List products;
  bool loaded = false;

  @override
  Stream<SuggestedProductsState> mapEventToState(
    SuggestedProductsEvent event,
  ) async* {
    if (event is SuggestedProductsInitEvent) {
      if (!loaded) {
        print('[sys] : fetching suggested products');
        final failureOrSuggested = await getSuggested(
          GetSuggestedParams(event.userId),
        );
        yield* failureOrSuggested.fold(
          (failure) async* {
            print('[err] : failed to fetch suggested products ${failure.code}');
          },
          (suggested) async* {
            print('[sys] : suggested products fetched');
            this.products = suggested;
            this.loaded = true;
            yield SuggestedProductsLoaded(this.products);
          },
        );
      } else {
        yield SuggestedProductsLoaded(this.products);
      }
    }

    if (event is SuggestedProductInitCart) {
      yield SuggestedProductsInitial();
      for (int i = 0; i < this.products.length; ++i) {
        var value = event.cart.cart[this.products[i].productId];
        if (value != null) {
          this.products[i].quantity = value.toDouble();
        } else {
          this.products[i].quantity = 0.0;
        }
      }
      yield SuggestedProductsLoaded(this.products);
    }

    if (event is UpdateProductQty) {
      yield SuggestedProductsInitial();
      this.products[this.products.indexOf(event.product)].quantity = event.qty;
      yield SuggestedProductsLoaded(this.products);
    }
  }
}
