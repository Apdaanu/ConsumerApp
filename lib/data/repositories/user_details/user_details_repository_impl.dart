import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/error/exceptions.dart';
import 'package:freshOk/core/netowrk/network_info.dart';
import 'package:freshOk/data/datasources/user_details/user_details_local_datasource.dart';
import 'package:freshOk/data/datasources/user_details/user_details_remote_datasource.dart';
import 'package:freshOk/data/models/user_details_model.dart';
import 'package:freshOk/domain/entities/user_details.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freshOk/domain/repositories/user_details/user_details_repository.dart';

class UserDetailsRepositoryImpl implements UserDetailsRepository {
  final UserDetailsLocalDatasource localDatasource;
  final UserDetailsRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  UserDetailsRepositoryImpl({
    @required this.localDatasource,
    @required this.remoteDatasource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserDetails>> getUserDetails() async {
    try {
      final UserDetails userDetails = await localDatasource.getUserDetails();
      return Right(userDetails);
    } on CacheException {
      if (await networkInfo.isConnected) {
        try {
          UserDetails userDetails = await remoteDatasource.getUserDetails();
          await localDatasource.setUserDetails(userDetails);
          return Right(userDetails);
        } on ServerException {
          return Left(ServerFailure());
        }
      } else {
        return Left(ConnectionFailure());
      }
    }
  }

  @override
  Future<Either<Failure, UserDetails>> updateUserDetails({
    @required String name,
    @required String address,
    @required String cityId,
    @required String areaId,
    @required String landmark,
    @required String pin,
    @required String imageUrl,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final UserDetailsModel userDetailsModel =
            await remoteDatasource.updateUserDetails(
          name: name,
          address: address,
          cityId: cityId,
          areaId: areaId,
          landmark: landmark,
          pin: pin,
          imageUrl: imageUrl,
        );
        await localDatasource.setUserDetails(userDetailsModel);
        return Right(userDetailsModel);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
