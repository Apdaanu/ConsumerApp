import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/error/failure.dart';

abstract class LogoutRepository {
  Future<Either<Failure, void>> logout();
}
