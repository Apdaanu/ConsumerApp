import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:freshOk/core/error/exceptions.dart';

import 'package:freshOk/core/error/failure.dart';
import 'package:freshOk/core/netowrk/network_info.dart';
import 'package:freshOk/data/datasources/referral/referral_remote_datasource.dart';
import 'package:freshOk/data/models/referral/referral_model.dart';

import 'package:freshOk/domain/entities/referral/referral.dart';

import '../../../domain/repositories/referral/referral_repository.dart';

class ReferralRepositoryImpl implements ReferralRepository {
  final ReferralRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  ReferralRepositoryImpl({
    @required this.remoteDatasource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, Referral>> getReferrals() async {
    if (await networkInfo.isConnected) {
      try {
        final ReferralModel referrals = await remoteDatasource.getReferrals();
        return Right(referrals);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, double>> getFreshOkCredits(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final double credits = await remoteDatasource.getFreshOkCredits(userId);
        return Right(credits);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
