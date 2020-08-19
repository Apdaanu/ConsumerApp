import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/entities/categories/product.dart';
import 'package:freshOk/domain/entities/order/local_cart.dart';
import 'package:freshOk/domain/usecases/orders/clear_local_cart.dart';
import 'package:freshOk/domain/usecases/orders/get_local_cart.dart';
import 'package:freshOk/domain/usecases/orders/remove_from_local_cart.dart';
import 'package:freshOk/domain/usecases/orders/set_local_cart.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetLocalCart getLocalCart;
  final SetLocalCart setLocalCart;
  final RemoveFromLocalCart removeFromLocalCart;
  final ClearLocalCart clearLocalCart;

  CartBloc({
    @required this.getLocalCart,
    @required this.setLocalCart,
    @required this.removeFromLocalCart,
    @required this.clearLocalCart,
  }) : super(CartInitial());

  LocalCart cart;

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    if (event is CartInitEvent) {
      print('[sys] : Setting up local cart');
      final failureOrCart = await getLocalCart(NoParams());
      yield* failureOrCart.fold(
        (failure) async* {},
        (cart) async* {
          print('[sys] : local cart fetched');
          this.cart = cart;
          yield CartLoaded(cart);
        },
      );
    }
    if (event is CartIncEvent) {
      if (event.product.quantity <= event.product.maxQty) {
        yield CartInitial();
        double qty;
        if (event.product.quantity == 0) {
          qty = event.product.minQty;
        } else if (event.product.quantity + event.product.unitQty <=
            event.product.maxQty) {
          qty = event.product.quantity + event.product.unitQty;
        } else {
          qty = event.product.maxQty;
        }

        final failureOrCart = await setLocalCart(
          SetLocalCartParams(
            productId: event.product.productId,
            qty: qty,
          ),
        );
        yield* failureOrCart.fold(
          (failure) async* {},
          (cart) async* {
            this.cart = cart;
            event.next(qty);
            yield CartLoaded(this.cart);
          },
        );
      }
    }
    if (event is CartDecEvent) {
      yield CartInitial();
      var failureOrCart;
      if (event.product.quantity - event.product.unitQty >=
          event.product.minQty) {
        failureOrCart = await setLocalCart(
          SetLocalCartParams(
            productId: event.product.productId,
            qty: event.product.quantity - event.product.unitQty,
          ),
        );
      } else if (event.product.quantity == event.product.minQty) {
        failureOrCart = await removeFromLocalCart(
          RemoveFromLocalCartParams(event.product.productId),
        );
      } else {
        failureOrCart = await setLocalCart(
          SetLocalCartParams(
            productId: event.product.productId,
            qty: event.product.minQty,
          ),
        );
      }
      yield* failureOrCart.fold(
        (failure) async* {},
        (cart) async* {
          this.cart = cart;
          if (event.product.quantity - event.product.unitQty >=
              event.product.minQty) {
            event.next(event.product.quantity - event.product.unitQty);
          } else if (event.product.quantity == event.product.minQty) {
            event.next(0.0);
          } else {
            event.next(event.product.minQty);
          }
          yield CartLoaded(this.cart);
        },
      );
    }

    if (event is CartRemEvent) {
      yield CartInitial();
      final failureOrCart = await removeFromLocalCart(
        RemoveFromLocalCartParams(event.product.productId),
      );
      yield* failureOrCart.fold(
        (failure) async* {},
        (cart) async* {
          this.cart = cart;
          event.next();
          yield CartLoaded(this.cart);
        },
      );
    }

    if (event is CartClearEvent) {
      yield CartInitial();
      final failureOrCart = await clearLocalCart(NoParams());
      yield* failureOrCart.fold(
        (failure) async* {},
        (voidRes) async* {
          this.cart = LocalCart({});
          yield CartLoaded(this.cart);
        },
      );
    }
  }
}
