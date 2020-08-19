import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/error/exceptions.dart';

import 'package:freshOk/core/error/failure.dart';
import 'package:freshOk/core/netowrk/network_info.dart';
import 'package:freshOk/data/datasources/mitra/mitra_remote_datasource.dart';

import '../../../domain/repositories/mitra/mitra_repository.dart';

class MitraRepositoryImpl implements MitraRepository {
  final MitraRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  MitraRepositoryImpl({
    @required this.remoteDatasource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, List>> getMitras(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final List mitras = await remoteDatasource.getMitras(userId);
        return Right(mitras);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> setMitra({
    String mitraId,
    String userId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.setMitra(
          mitraId: mitraId,
          userId: userId,
        );
        return Right(null);
      } on ServerException {
        return left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
