import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/error/failure.dart';

abstract class MitraRepository {
  Future<Either<Failure, List>> getMitras(String userId);

  Future<Either<Failure, void>> setMitra({
    @required String mitraId,
    @required String userId,
  });
}
