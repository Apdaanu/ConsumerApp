import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/repositories/categories/recepie_repository.dart';

class GetLikedRecepies implements Usecase<List, GetLikedRecepiesParams> {
  final RecepieRepository repository;

  GetLikedRecepies(this.repository);

  @override
  Future<Either<Failure, List>> call(GetLikedRecepiesParams params) async {
    return await repository.getLikedRecepies(params.userId);
  }
}

class GetLikedRecepiesParams extends Equatable {
  final String userId;

  GetLikedRecepiesParams(this.userId);

  @override
  List<Object> get props => [userId];
}
