import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/order/local_cart.dart';
import '../../repositories/orders/cart_repository.dart';

class GetLocalCart implements Usecase<LocalCart, NoParams> {
  final CartRepository repository;

  GetLocalCart(this.repository);

  @override
  Future<Either<Failure, LocalCart>> call(NoParams params) async {
    return await repository.getLocalCart();
  }
}
