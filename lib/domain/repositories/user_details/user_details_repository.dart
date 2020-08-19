import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:freshOk/domain/entities/user_details.dart';

abstract class UserDetailsRepository {
  Future<Either<Failure, UserDetails>> getUserDetails();

  Future<Either<Failure, UserDetails>> updateUserDetails({
    @required String name,
    @required String address,
    @required String cityId,
    @required String areaId,
    @required String landmark,
    @required String pin,
    @required String imageUrl,
  });
}
