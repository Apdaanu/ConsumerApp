import 'package:freshOk/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/repositories/orders/cart_repository.dart';

class ClearLocalCart implements Usecase<void, NoParams> {
  final CartRepository repository;

  ClearLocalCart(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.clearLocalCart();
  }
}
