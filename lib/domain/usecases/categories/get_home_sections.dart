import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/repositories/categories/home_section_repository.dart';

class GetHomeSections implements Usecase<List<dynamic>, SectionParams> {
  final HomeSectionRepository repository;

  GetHomeSections({
    @required this.repository,
  });

  @override
  Future<Either<Failure, List<dynamic>>> call(params) async {
    return await repository.getSections(params.userId);
  }
}

class SectionParams extends Equatable {
  final String userId;

  SectionParams({@required this.userId});

  @override
  List<Object> get props => [userId];
}
