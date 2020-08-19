import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/repositories/categories/recepie_repository.dart';

class GetRecepies implements Usecase<List, GetRecepiesParams> {
  final RecepieRepository repository;

  GetRecepies(this.repository);

  @override
  Future<Either<Failure, List>> call(params) async {
    return await repository.getRecepies(
      userId: params.userId,
      sectionId: params.sectionId,
      categoryId: params.categoryId,
      type: params.type,
    );
  }
}

class GetRecepiesParams extends Equatable {
  final String userId;
  final String sectionId;
  final String categoryId;
  final String type;

  GetRecepiesParams({
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
