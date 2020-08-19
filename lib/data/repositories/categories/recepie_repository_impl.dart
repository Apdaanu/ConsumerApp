import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/error/failure.dart';
import '../../../core/netowrk/network_info.dart';
import '../../../domain/entities/categories/recepie.dart';
import '../../../domain/repositories/categories/recepie_repository.dart';
import '../../datasources/categories/recepie_remote_datasource.dart';

class RecepieRepositoryImpl implements RecepieRepository {
  final RecepieRemoteDatasource datasource;
  final NetworkInfo networkInfo;

  RecepieRepositoryImpl({
    @required this.datasource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, List>> getRecepieSections(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final List sections = await datasource.getRecepieSections(userId);
        return Right(sections);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List>> getAllRecepies() async {
    if (await networkInfo.isConnected) {
      try {
        final List recepies = await datasource.getAllRecepies();
        return Right(recepies);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List>> getMyRecepies(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final List recepies = await datasource.getMyRecepies(userId);
        return Right(recepies);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List>> getLikedRecepies(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final List recepies = await datasource.getLikedRecepies(userId);
        return Right(recepies);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Recepie>> getRecepieDetails(String recepieId) async {
    if (await networkInfo.isConnected) {
      try {
        final Recepie recepie = await datasource.getRecepieDetails(recepieId);
        return Right(recepie);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List>> getRecepies({
    @required String userId,
    @required String sectionId,
    @required String categoryId,
    @required String type,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final List recepies = await datasource.getRecepies(
          userId: userId,
          sectionId: sectionId,
          categoryId: categoryId,
          type: type,
        );
        return Right(recepies);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> likeRecepie({
    @required String recepieId,
    @required String userId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await datasource.likeRecepie(
          recepieId: recepieId,
          userId: userId,
        );
        return Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List>> getDishTypes() async {
    if (await networkInfo.isConnected) {
      try {
        final List dishTypes = await datasource.getDishTypes();
        return Right(dishTypes);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List>> getCuisinesTypes() async {
    if (await networkInfo.isConnected) {
      try {
        final List dishTypes = await datasource.getCuisinesTypes();
        return Right(dishTypes);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List>> searchRecepies(String search) async {
    if (await networkInfo.isConnected) {
      try {
        final List searchRes = await datasource.searchRecepies(search);
        return Right(searchRes);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
