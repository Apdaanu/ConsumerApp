import 'package:equatable/equatable.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/repositories/mitra/mitra_repository.dart';

class GetMitras implements Usecase<List, GetMitrasParams> {
  final MitraRepository repository;

  GetMitras(this.repository);

  @override
  Future<Either<Failure, List>> call(GetMitrasParams params) async {
    return await repository.getMitras(params.userId);
  }
}

class GetMitrasParams extends Equatable {
  final String userId;

  GetMitrasParams(this.userId);

  @override
  List<Object> get props => [userId];
}
