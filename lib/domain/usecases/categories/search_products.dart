import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/categories/product_repository.dart';

class SearchProducts implements Usecase<List, SearchParams> {
  final ProductRepository repository;

  SearchProducts(this.repository);

  @override
  Future<Either<Failure, List>> call(SearchParams params) async {
    return await repository.searchProducts(params.search);
  }
}

class SearchParams extends Equatable {
  final String search;

  SearchParams(this.search);

  @override
  List<Object> get props => [search];
}
