import 'package:dartz/dartz.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:freshOk/domain/entities/referral/referral.dart';

abstract class ReferralRepository {
  Future<Either<Failure, Referral>> getReferrals();

  Future<Either<Failure, double>> getFreshOkCredits(String userId);
}
