import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/entities/order/cart.dart';
import 'package:freshOk/domain/entities/order/local_cart.dart';
import 'package:freshOk/domain/repositories/orders/cart_repository.dart';

class SetRemoteCart implements Usecase<Cart, SetRemoteCartParams> {
  final CartRepository repository;

  SetRemoteCart(this.repository);

  @override
  Future<Either<Failure, Cart>> call(params) async {
    return await repository.setRemoteCart(
      userId: params.userId,
      localCart: params.localCart,
    );
  }
}

class SetRemoteCartParams extends Equatable {
  final String userId;
  final LocalCart localCart;

  SetRemoteCartParams({
    @required this.userId,
    @required this.localCart,
  });

  @override
  List<Object> get props => [
        userId,
        localCart,
      ];
}
