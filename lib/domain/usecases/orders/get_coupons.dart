import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/repositories/orders/cart_repository.dart';

class GetCoupons implements Usecase<List, GetCouponsParams> {
  final CartRepository repository;

  GetCoupons(this.repository);

  @override
  Future<Either<Failure, List>> call(GetCouponsParams params) async {
    return await repository.getCoupons(params.userId);
  }
}

class GetCouponsParams extends Equatable {
  final String userId;

  GetCouponsParams(this.userId);

  @override
  List<Object> get props => [userId];
}
