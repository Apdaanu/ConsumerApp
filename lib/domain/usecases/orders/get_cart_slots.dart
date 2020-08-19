import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/order/book_slot.dart';
import '../../repositories/orders/cart_repository.dart';

class GetCartSlots implements Usecase<BookSlot, NoParams> {
  final CartRepository repository;

  GetCartSlots(this.repository);

  @override
  Future<Either<Failure, BookSlot>> call(NoParams params) async {
    return await repository.getSlots();
  }
}
