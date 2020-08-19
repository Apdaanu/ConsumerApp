import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/error/failure.dart';

abstract class HomeSectionRepository {
  Future<Either<Failure, List<dynamic>>> getSections(String userId);
}
