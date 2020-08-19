import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/categories/product_repository.dart';

class GetProductsBasesOnSearch implements Usecase<List, String> {
  final ProductRepository repository;

  GetProductsBasesOnSearch(this.repository);

  @override
  Future<Either<Failure, List>> call(String categoryId) async {
    return await repository.getProductsBasedOnSearch(categoryId);
  }
}
