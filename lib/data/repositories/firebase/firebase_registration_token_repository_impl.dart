import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/error/exceptions.dart';
import 'package:freshOk/core/error/failure.dart';

import 'package:dartz/dartz.dart';
import 'package:freshOk/core/netowrk/network_info.dart';
import 'package:freshOk/data/datasources/firebase/firebase_registration_token_datasource.dart';

import '../../../domain/repositories/firebase/firebase_registration_token_repository.dart';

class FirebaseRegistrationTokenRepositoryImpl
    implements FirebaseRegistrationTokenRepository {
  final FirebaseRegistrationTokenDatasource datasource;
  final NetworkInfo networkInfo;

  FirebaseRegistrationTokenRepositoryImpl({
    @required this.datasource,
    @required this.networkInfo,
  });

  Future<Either<Failure, void>> postToken({
    @required String userId,
    @required String token,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await datasource.postToken(
          userId: userId,
          token: token,
        );
        return Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
