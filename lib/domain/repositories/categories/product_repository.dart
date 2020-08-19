import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/error/failure.dart';

abstract class ProductRepository {
  Future<Either<Failure, List>> getProducts({
    @required String userId,
    @required String sectionId,
    @required String categoryId,
    @required String type,
  });

  Future<Either<Failure, List>> getSuggestedProducts(String userId);

  Future<Either<Failure, List>> searchProducts(String search);

  Future<Either<Failure, List>> getProductsBasedOnSearch(String categoryId);
}
