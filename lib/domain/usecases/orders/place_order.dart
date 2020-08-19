import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/entities/order/order.dart';
import 'package:freshOk/domain/repositories/orders/order_repository.dart';

class PlaceOrder implements Usecase<Order, PlaceOrderParams> {
  final OrderRepository repository;

  PlaceOrder(this.repository);

  @override
  Future<dartz.Either<Failure, Order>> call(PlaceOrderParams params) async {
    return await repository.placeOrder(
      userId: params.userId,
      couponId: params.couponId,
      usedFreshOkCredit: params.usedFreshOkCredit,
      paymentResponse: params.paymentResponse,
      paymentType: params.paymentType,
      date: params.date,
      slotId: params.slotId,
    );
  }
}

class PlaceOrderParams extends Equatable {
  final String userId;
  final String couponId;
  final String paymentType;
  final double usedFreshOkCredit;
  final String date;
  final String slotId;
  final paymentResponse;

  PlaceOrderParams({
    @required this.userId,
    @required this.couponId,
    @required this.usedFreshOkCredit,
    @required this.paymentResponse,
    @required this.paymentType,
    @required this.slotId,
    @required this.date,
  });

  @override
  List<Object> get props => [
        userId,
        couponId,
        usedFreshOkCredit,
        paymentResponse,
        paymentType,
      ];
}
