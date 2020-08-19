import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/data/datasources/login/basic_user_local_datasource.dart';
import 'package:freshOk/data/datasources/login/basic_user_remote_datasource.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/error/failure.dart';
import '../../../core/netowrk/network_info.dart';
import '../../../domain/entities/basic_user.dart';
import '../../../domain/repositories/login/basic_user_repository.dart';

class BasicUserRepositoryImpl implements BasicUserRepository {
  final BasicUserRemoteDatasource remoteDatasource;
  final BasicUserLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  BasicUserRepositoryImpl({
    @required this.remoteDatasource,
    @required this.localDatasource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, BasicUser>> getBasicUser() async {
    try {
      final localBasicUser = await localDatasource.getBasicUser();
      return Right(localBasicUser);
    } on CacheException {
      if (await networkInfo.isConnected) {
        try {
          final remoteBasicUser = await remoteDatasource.getBasicUser();
          localDatasource.cacheBasicUser(remoteBasicUser);
          return Right(remoteBasicUser);
        } on ServerException {
          return Left(ServerFailure());
        }
      } else {
        return Left(ConnectionFailure());
      }
    }
  }
}
