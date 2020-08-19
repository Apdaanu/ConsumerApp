import 'package:freshOk/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/repositories/user_details/renew_user_details_repository.dart';

class RenewUserDetailsCache extends Usecase<bool, NoParams> {
  final RenewUserDetailsRepository repository;

  RenewUserDetailsCache(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.renewUserDetails();
  }
}
