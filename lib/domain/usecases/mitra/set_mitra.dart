import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/repositories/mitra/mitra_repository.dart';

class SetMitra implements Usecase<void, SetMitraParams> {
  final MitraRepository repository;

  SetMitra(this.repository);

  @override
  Future<Either<Failure, void>> call(SetMitraParams params) async {
    return await repository.setMitra(
      mitraId: params.mitraId,
      userId: params.userId,
    );
  }
}

class SetMitraParams extends Equatable {
  final String mitraId;
  final String userId;

  SetMitraParams({
    @required this.mitraId,
    @required this.userId,
  });

  @override
  List<Object> get props => [
        mitraId,
        userId,
      ];
}
