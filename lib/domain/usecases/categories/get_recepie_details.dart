import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/entities/categories/recepie.dart';
import 'package:freshOk/domain/repositories/categories/recepie_repository.dart';

class GetRecepieDetails implements Usecase<Recepie, GetRecepieParams> {
  final RecepieRepository repository;

  GetRecepieDetails(this.repository);

  @override
  Future<Either<Failure, Recepie>> call(GetRecepieParams params) async {
    return await repository.getRecepieDetails(params.recepieId);
  }
}

class GetRecepieParams extends Equatable {
  final String recepieId;

  GetRecepieParams(this.recepieId);

  @override
  List<Object> get props => [recepieId];
}
