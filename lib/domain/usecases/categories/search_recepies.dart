import 'package:freshOk/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/repositories/categories/recepie_repository.dart';

class SearchRecepies implements Usecase<List, String> {
  final RecepieRepository repository;

  SearchRecepies(this.repository);

  @override
  Future<Either<Failure, List>> call(String params) async {
    return await repository.searchRecepies(params);
  }
}
