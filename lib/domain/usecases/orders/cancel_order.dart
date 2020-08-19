import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/orders/order_repository.dart';

class CancelOrder implements Usecase<void, CancelOrderParams> {
  final OrderRepository repository;

  CancelOrder(this.repository);

  @override
  Future<Either<Failure, void>> call(CancelOrderParams params) async {
    return await repository.cancelOrder(
      userId: params.userId,
      orderId: params.orderId,
    );
  }
}

class CancelOrderParams extends Equatable {
  final String orderId;
  final String userId;

  CancelOrderParams({
    @required this.orderId,
    @required this.userId,
  });

  @override
  List<Object> get props => [
        orderId,
        userId,
      ];
}
