import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/cupertino.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/error/failure.dart';
import '../../../core/netowrk/network_info.dart';
import '../../../domain/entities/order/order.dart';
import '../../../domain/repositories/orders/order_repository.dart';
import '../../datasources/orders/order_remote_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  OrderRepositoryImpl({
    @required this.remoteDatasource,
    @required this.networkInfo,
  });

  @override
  Future<dartz.Either<Failure, List>> getOrders({String userId}) async {
    if (await networkInfo.isConnected) {
      try {
        final List orders = await remoteDatasource.getOrders(userId: userId);
        return dartz.Right(orders);
      } on ServerException {
        return dartz.Left(ServerFailure());
      }
    } else {
      return dartz.Left(ConnectionFailure());
    }
  }

  @override
  Future<dartz.Either<Failure, Order>> getOrderDetails({
    @required String userId,
    @required String orderId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final Order orderDetails = await remoteDatasource.getOrderDetails(
          userId: userId,
          orderId: orderId,
        );
        return dartz.Right(orderDetails);
      } on ServerException {
        return dartz.Left(ServerFailure());
      }
    } else {
      return dartz.Left(ConnectionFailure());
    }
  }

  @override
  Future<dartz.Either<Failure, Order>> placeOrder({
    @required String userId,
    @required String couponId,
    @required double usedFreshOkCredit,
    @required paymentResponse,
    @required String paymentType,
    @required String slotId,
    @required String date,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final Order order = await remoteDatasource.placeOrder(
          userId: userId,
          couponId: couponId,
          usedFreshOkCredit: usedFreshOkCredit,
          paymentResponse: paymentResponse,
          paymentType: paymentType,
          date: date,
        );
        return dartz.Right(order);
      } on ServerException {
        return dartz.Left(ServerFailure());
      }
    } else {
      return dartz.Left(ConnectionFailure());
    }
  }

  @override
  Future<dartz.Either<Failure, void>> cancelOrder({
    @required String userId,
    @required String orderId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.cancelOrder(
          userId: userId,
          orderId: orderId,
        );
        return dartz.Right(null);
      } on ServerException {
        return dartz.Left(ServerFailure());
      }
    } else {
      return dartz.Left(ConnectionFailure());
    }
  }
}
