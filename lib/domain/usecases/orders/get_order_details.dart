import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/entities/order/order.dart';
import 'package:freshOk/domain/repositories/orders/order_repository.dart';

class GetOrderDetails implements Usecase<Order, GetOrderDetailsParams> {
  final OrderRepository repository;

  GetOrderDetails(this.repository);

  @override
  Future<dartz.Either<Failure, Order>> call(
      GetOrderDetailsParams params) async {
    return await repository.getOrderDetails(
      userId: params.userId,
      orderId: params.orderId,
    );
  }
}

class GetOrderDetailsParams extends Equatable {
  final String userId;
  final String orderId;

  GetOrderDetailsParams({
    @required this.userId,
    @required this.orderId,
  });

  @override
  List<Object> get props => [
        userId,
        orderId,
      ];
}
