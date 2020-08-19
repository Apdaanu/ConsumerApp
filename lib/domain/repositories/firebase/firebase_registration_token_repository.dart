import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/error/failure.dart';

abstract class FirebaseRegistrationTokenRepository {
  Future<Either<Failure, void>> postToken({
    @required String userId,
    @required String token,
  });
}
