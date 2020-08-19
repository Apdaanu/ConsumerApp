import 'package:freshOk/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/entities/referral/referral.dart';
import 'package:freshOk/domain/repositories/referral/referral_repository.dart';

class GetReferrals implements Usecase<Referral, NoParams> {
  final ReferralRepository repository;

  GetReferrals(this.repository);

  @override
  Future<Either<Failure, Referral>> call(NoParams params) async {
    return await repository.getReferrals();
  }
}
