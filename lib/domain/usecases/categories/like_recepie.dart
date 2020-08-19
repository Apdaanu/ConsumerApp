import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/repositories/categories/recepie_repository.dart';

class LikeRecepie implements Usecase<void, LikeRecepieParams> {
  final RecepieRepository repository;

  LikeRecepie(this.repository);

  @override
  Future<Either<Failure, void>> call(LikeRecepieParams params) async {
    return await repository.likeRecepie(
      recepieId: params.recepieId,
      userId: params.userId,
    );
  }
}

class LikeRecepieParams extends Equatable {
  final String userId;
  final String recepieId;

  LikeRecepieParams({
    @required this.userId,
    @required this.recepieId,
  });

  @override
  List<Object> get props => [recepieId, userId];
}
