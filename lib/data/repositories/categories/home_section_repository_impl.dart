import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/error/exceptions.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:freshOk/core/netowrk/network_info.dart';
import 'package:freshOk/data/datasources/categories/home_sections_remote_datasource.dart';
import 'package:freshOk/domain/repositories/categories/home_section_repository.dart';

class HomeSectionRepositoryImpl implements HomeSectionRepository {
  final HomeSectionRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  HomeSectionRepositoryImpl({
    @required this.remoteDatasource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, List>> getSections(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final List<dynamic> sections =
            await remoteDatasource.getSections(userId);
        return Right(sections);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
