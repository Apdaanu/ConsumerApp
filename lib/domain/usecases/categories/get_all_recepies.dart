import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/categories/recepie_repository.dart';

class GetAllRecepies implements Usecase<List, NoParams> {
  final RecepieRepository repository;

  GetAllRecepies(this.repository);

  @override
  Future<Either<Failure, List>> call(params) async {
    return await repository.getAllRecepies();
  }
}
