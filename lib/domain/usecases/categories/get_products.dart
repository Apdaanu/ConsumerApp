import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/repositories/categories/product_repository.dart';

class GetProducts implements Usecase<List, GetProductsParams> {
  final ProductRepository repository;

  GetProducts(this.repository);

  @override
  Future<Either<Failure, List>> call(params) async {
    return await repository.getProducts(
      userId: params.userId,
      sectionId: params.sectionId,
      categoryId: params.categoryId,
      type: params.type,
    );
  }
}

class GetProductsParams extends Equatable {
  final String userId;
  final String sectionId;
  final String categoryId;
  final String type;

  GetProductsParams({
    @required this.userId,
    @required this.sectionId,
    @required this.categoryId,
    @required this.type,
  });
  @override
  List<Object> get props => [
        userId,
        sectionId,
        categoryId,
        type,
      ];
}
