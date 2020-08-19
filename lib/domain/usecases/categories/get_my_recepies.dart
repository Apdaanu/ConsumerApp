import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/repositories/categories/recepie_repository.dart';

class GetMyRecepies implements Usecase<List, GetMyRecepiesParams> {
  final RecepieRepository repository;

  GetMyRecepies(this.repository);

  @override
  Future<Either<Failure, List>> call(GetMyRecepiesParams params) async {
    return await repository.getMyRecepies(params.userId);
  }
}

class GetMyRecepiesParams extends Equatable {
  final String userId;

  GetMyRecepiesParams(this.userId);

  @override
  List<Object> get props => [userId];
}
