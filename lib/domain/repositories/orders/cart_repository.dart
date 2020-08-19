import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../core/error/failure.dart';
import '../../entities/order/book_slot.dart';
import '../../entities/order/cart.dart';
import '../../entities/order/local_cart.dart';

abstract class CartRepository {
  Future<Either<Failure, LocalCart>> getLocalCart();

  Future<Either<Failure, LocalCart>> setLocalCart({
    @required String productId,
    @required double qty,
  });

  Future<Either<Failure, LocalCart>> removeFromLocalCart(String productId);

  Future<Either<Failure, void>> clearLocalCart();

  Future<Either<Failure, Cart>> setRemoteCart({
    @required String userId,
    @required LocalCart localCart,
  });

  Future<Either<Failure, List>> getCoupons(String userId);

  Future<Either<Failure, BookSlot>> getSlots();
}
