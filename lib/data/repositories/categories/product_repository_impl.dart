import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/error/exceptions.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freshOk/core/netowrk/network_info.dart';
import 'package:freshOk/data/datasources/categories/product_remote_datasource.dart';
import 'package:freshOk/domain/repositories/categories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource datasource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    @required this.datasource,
    @required this.networkInfo,
  });
  @override
  Future<Either<Failure, List>> getProducts({
    @required String userId,
    @required String sectionId,
    @required String categoryId,
    @required String type,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final List products = await datasource.getProducts(
          userId: userId,
          sectionId: sectionId,
          categoryId: categoryId,
          type: type,
        );
        return Right(products);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List>> getSuggestedProducts(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final List products = await datasource.getSuggestions(userId);
        return Right(products);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List>> searchProducts(String search) async {
    if (await networkInfo.isConnected) {
      try {
        final List products = await datasource.searchProducts(search);
        return Right(products);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List>> getProductsBasedOnSearch(
      String categoryId) async {
    if (await networkInfo.isConnected) {
      try {
        final List products =
            await datasource.getProductsBasedOnSearch(categoryId);
        return Right(products);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
