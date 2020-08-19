import 'package:freshOk/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/repositories/categories/recepie_repository.dart';

class GetCuisines implements Usecase<List, NoParams> {
  final RecepieRepository repository;

  GetCuisines(this.repository);

  @override
  Future<Either<Failure, List>> call(NoParams params) async {
    return await repository.getCuisinesTypes();
  }
}
