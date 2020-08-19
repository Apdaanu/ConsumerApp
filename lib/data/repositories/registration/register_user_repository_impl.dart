import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/data/datasources/login/basic_user_local_datasource.dart';
import 'package:freshOk/data/models/basic_user_model.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/error/failure.dart';
import '../../../core/netowrk/network_info.dart';
import '../../../domain/repositories/registerUser/register_user_repository.dart';
import '../../datasources/registration/register_user_datasource.dart';
import '../../datasources/user_details/user_details_local_datasource.dart';
import '../../models/user_details_model.dart';

class RegisterUserRepositoryImpl implements RegisterUserRepository {
  final RegisterUserDatasource remoteDatasource;
  final UserDetailsLocalDatasource userDetailsLocalDatasource;
  final BasicUserLocalDatasource basicUserLocalDatasource;
  final NetworkInfo networkInfo;

  RegisterUserRepositoryImpl({
    @required this.remoteDatasource,
    @required this.userDetailsLocalDatasource,
    @required this.basicUserLocalDatasource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserDetailsModel>> registerUser({
    @required String name,
    @required String cityId,
    @required String areaId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        UserDetailsModel userDetailsModel = await remoteDatasource.registerUser(
          name: name,
          cityId: cityId,
          areaId: areaId,
        );
        await userDetailsLocalDatasource.setUserDetails(userDetailsModel);
        BasicUserModel basicUser =
            await basicUserLocalDatasource.getBasicUser();
        final json = basicUser.toJson();
        json['newUser'] = false;
        await basicUserLocalDatasource
            .cacheBasicUser(BasicUserModel.fromJson(json));
        return Right(userDetailsModel);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> activateReferral({
    @required String referralCode,
    @required String userId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.activateReferral(
          referralCode: referralCode,
          userId: userId,
        );
        print('[sys] : Referral Code activated');
        return Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
