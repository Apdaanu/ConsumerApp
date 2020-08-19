import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:freshOk/domain/entities/order/book_slot.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/error/failure.dart';
import '../../../core/netowrk/network_info.dart';
import '../../../domain/entities/order/cart.dart';
import '../../../domain/entities/order/local_cart.dart';
import '../../../domain/repositories/orders/cart_repository.dart';
import '../../datasources/orders/cart_local_datasource.dart';
import '../../datasources/orders/cart_remote_datasource.dart';
import '../../models/order/cart_model.dart';
import '../../models/order/local_cart_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDatasource localDatasource;
  final CartRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  CartRepositoryImpl({
    @required this.localDatasource,
    @required this.networkInfo,
    @required this.remoteDatasource,
  });

  @override
  Future<Either<Failure, LocalCart>> getLocalCart() async {
    final LocalCartModel cartModel = await localDatasource.getLoaclCart();
    return Right(cartModel);
  }

  @override
  Future<Either<Failure, LocalCart>> setLocalCart({
    @required String productId,
    @required double qty,
  }) async {
    final LocalCartModel cartModel = await localDatasource.setLoacalCart(
      productId: productId,
      qty: qty,
    );
    return Right(cartModel);
  }

  @override
  Future<Either<Failure, LocalCart>> removeFromLocalCart(
      String productId) async {
    final LocalCartModel cartModel =
        await localDatasource.removeFromLocalCart(productId);
    return Right(cartModel);
  }

  @override
  Future<Either<Failure, Cart>> setRemoteCart({
    String userId,
    LocalCart localCart,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final CartModel cartModel = await remoteDatasource.setRemoteCart(
          userId: userId,
          localCartModel: localCart,
        );
        return Right(cartModel);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List>> getCoupons(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final List coupons = await remoteDatasource.getCoupons(userId);
        return Right(coupons);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearLocalCart() async {
    await localDatasource.clearLocalCart();
    return Right(null);
  }

  @override
  Future<Either<Failure, BookSlot>> getSlots() async {
    if (await networkInfo.isConnected) {
      try {
        final BookSlot slots = await remoteDatasource.getSlots();
        return Right(slots);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
