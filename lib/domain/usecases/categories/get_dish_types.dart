import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/categories/recepie_repository.dart';

class GetDishTypes implements Usecase<List, NoParams> {
  final RecepieRepository repository;

  GetDishTypes(this.repository);

  @override
  Future<Either<Failure, List>> call(NoParams params) async {
    return await repository.getDishTypes();
  }
}
