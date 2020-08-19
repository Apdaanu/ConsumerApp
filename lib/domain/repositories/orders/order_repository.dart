import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/foundation.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:freshOk/domain/entities/order/order.dart';

abstract class OrderRepository {
  Future<dartz.Either<Failure, List>> getOrders({
    @required String userId,
  });

  Future<dartz.Either<Failure, Order>> getOrderDetails({
    @required String userId,
    @required String orderId,
  });

  Future<dartz.Either<Failure, Order>> placeOrder({
    @required String userId,
    @required String couponId,
    @required double usedFreshOkCredit,
    @required paymentResponse,
    @required String paymentType,
    @required String slotId,
    @required String date,
  });

  Future<dartz.Either<Failure, void>> cancelOrder({
    @required String userId,
    @required String orderId,
  });
}
