import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/error/exceptions.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:freshOk/core/netowrk/network_info.dart';
import 'package:freshOk/data/datasources/user_details/user_details_local_datasource.dart';
import 'package:freshOk/data/datasources/user_details/user_details_remote_datasource.dart';
import 'package:freshOk/data/models/user_details_model.dart';
import 'package:freshOk/domain/repositories/user_details/renew_user_details_repository.dart';

class RenewUserDetailsRepositoryImpl implements RenewUserDetailsRepository {
  final UserDetailsLocalDatasource localDatasource;
  final UserDetailsRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  RenewUserDetailsRepositoryImpl({
    @required this.localDatasource,
    @required this.remoteDatasource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, bool>> renewUserDetails() async {
    if (await networkInfo.isConnected) {
      try {
        UserDetailsModel userDetailsModel =
            await remoteDatasource.getUserDetails();
        await localDatasource.setUserDetails(userDetailsModel);
        return Right(true);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
