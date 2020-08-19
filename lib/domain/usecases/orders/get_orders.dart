import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/orders/order_repository.dart';

class GetOrders implements Usecase<List, GetOrdersParams> {
  final OrderRepository repository;

  GetOrders(this.repository);

  @override
  Future<Either<Failure, List>> call(GetOrdersParams params) async {
    return await repository.getOrders(userId: params.userId);
  }
}

class GetOrdersParams extends Equatable {
  final String userId;

  GetOrdersParams(this.userId);

  @override
  List<Object> get props => [];
}
