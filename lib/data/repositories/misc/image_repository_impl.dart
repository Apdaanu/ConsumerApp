import 'package:flutter/foundation.dart';
import 'package:freshOk/core/error/exceptions.dart';
import 'package:freshOk/core/error/failure.dart';

import 'package:dartz/dartz.dart';
import 'package:freshOk/core/netowrk/network_info.dart';
import 'package:freshOk/data/datasources/misc/image_remote_datasource.dart';

import 'dart:io';

import '../../../domain/repositories/misc/image_repository.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  ImageRepositoryImpl({
    @required this.remoteDatasource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, String>> uploadImage({
    String filename,
    File file,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final String imgUrl = await remoteDatasource.uploadImage(
          file: file,
          fileName: filename,
        );
        return Right(imgUrl);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
