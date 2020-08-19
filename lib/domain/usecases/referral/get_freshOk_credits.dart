import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/referral/referral_repository.dart';

class GetFreshOkCredits implements Usecase<double, GetFreshOkCreditsParams> {
  final ReferralRepository repository;

  GetFreshOkCredits(this.repository);

  @override
  Future<Either<Failure, double>> call(GetFreshOkCreditsParams params) async {
    return await repository.getFreshOkCredits(params.userId);
  }
}

class GetFreshOkCreditsParams extends Equatable {
  final String userId;

  GetFreshOkCreditsParams(this.userId);

  @override
  List<Object> get props => [userId];
}
