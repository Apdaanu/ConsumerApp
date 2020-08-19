import 'package:dartz/dartz.dart';
import 'package:freshOk/core/error/failure.dart';

abstract class RenewUserDetailsRepository {
  Future<Either<Failure, bool>> renewUserDetails();
}
