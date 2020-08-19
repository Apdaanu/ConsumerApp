import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/domain/entities/user_details.dart';

import '../../../core/error/failure.dart';

abstract class RegisterUserRepository {
  Future<Either<Failure, UserDetails>> registerUser({
    @required String name,
    @required String cityId,
    @required String areaId,
  });

  Future<Either<Failure, void>> activateReferral({
    @required String referralCode,
    @required String userId,
  });
}
