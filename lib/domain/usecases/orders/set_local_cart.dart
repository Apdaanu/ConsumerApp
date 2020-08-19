import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/entities/order/local_cart.dart';
import 'package:freshOk/domain/repositories/orders/cart_repository.dart';

class SetLocalCart implements Usecase<LocalCart, SetLocalCartParams> {
  final CartRepository repository;

  SetLocalCart(this.repository);

  @override
  Future<Either<Failure, LocalCart>> call(SetLocalCartParams params) async {
    return await repository.setLocalCart(
      productId: params.productId,
      qty: params.qty,
    );
  }
}

class SetLocalCartParams extends Equatable {
  final String productId;
  final double qty;

  SetLocalCartParams({
    @required this.productId,
    @required this.qty,
  });

  @override
  List<Object> get props => [
        productId,
        qty,
      ];
}
