import 'package:equatable/equatable.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/entities/order/local_cart.dart';
import 'package:freshOk/domain/repositories/orders/cart_repository.dart';

class RemoveFromLocalCart
    implements Usecase<LocalCart, RemoveFromLocalCartParams> {
  final CartRepository repository;

  RemoveFromLocalCart(this.repository);

  @override
  Future<Either<Failure, LocalCart>> call(params) async {
    return await repository.removeFromLocalCart(params.productId);
  }
}

class RemoveFromLocalCartParams extends Equatable {
  final String productId;

  RemoveFromLocalCartParams(this.productId);

  @override
  List<Object> get props => [productId];
}
