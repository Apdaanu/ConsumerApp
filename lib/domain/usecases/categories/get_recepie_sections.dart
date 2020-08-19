import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/repositories/categories/recepie_repository.dart';

class GetRecepieSections implements Usecase<List, GetSectionParams> {
  final RecepieRepository repository;

  GetRecepieSections(this.repository);

  @override
  Future<Either<Failure, List>> call(GetSectionParams params) async {
    return await repository.getRecepieSections(params.userId);
  }
}

class GetSectionParams extends Equatable {
  final String userId;

  GetSectionParams(this.userId);

  @override
  List<Object> get props => [userId];
}
