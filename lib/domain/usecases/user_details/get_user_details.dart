import 'package:freshOk/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/entities/user_details.dart';
import 'package:freshOk/domain/repositories/user_details/user_details_repository.dart';

class GetUserDetails extends Usecase<UserDetails, NoParams> {
  final UserDetailsRepository repository;

  GetUserDetails(this.repository);

  @override
  Future<Either<Failure, UserDetails>> call(NoParams params) async {
    return await repository.getUserDetails();
  }
}
