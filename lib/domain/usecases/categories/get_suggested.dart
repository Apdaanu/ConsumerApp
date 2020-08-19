import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/repositories/categories/product_repository.dart';

class GetSuggested implements Usecase<List, GetSuggestedParams> {
  final ProductRepository repository;

  GetSuggested(this.repository);

  @override
  Future<Either<Failure, List>> call(GetSuggestedParams params) async {
    return await repository.getSuggestedProducts(params.userId);
  }
}

class GetSuggestedParams extends Equatable {
  final String userId;

  GetSuggestedParams(this.userId);

  @override
  List<Object> get props => [userId];
}
