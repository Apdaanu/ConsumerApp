import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/error/exceptions.dart';
import 'package:freshOk/core/netowrk/network_info.dart';
import 'package:freshOk/data/datasources/login/basic_user_local_datasource.dart';
import 'package:freshOk/data/datasources/login/otp_handler_remote_datasource.dart';
import 'package:freshOk/domain/entities/basic_user.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freshOk/domain/repositories/login/otp_handler_repository.dart';

class OtpHandlerRepositoryImpl implements OtpHandlerRepository {
  final OtpHandlerRemoteDatasource remoteDatasource;
  final BasicUserLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  OtpHandlerRepositoryImpl({
    @required this.remoteDatasource,
    @required this.localDatasource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, bool>> sendOtp(int mob) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.sendOtp(mob);
        return Right(true);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, BasicUser>> verifyOtp({
    @required int mob,
    @required int otp,
    @required String status,
  }) async {
    try {
      final remoteBasicUser =
          await remoteDatasource.verifyOtp(mob: mob, otp: otp, status: status);
      await localDatasource.cacheBasicUser(remoteBasicUser);
      return Right(remoteBasicUser);
    } on VerificationException {
      return Left(VerificationFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
