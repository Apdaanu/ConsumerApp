import 'package:freshOk/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/entities/basic_user.dart';
import 'package:freshOk/domain/repositories/login/basic_user_repository.dart';

class GetBasicUser implements Usecase<BasicUser, NoParams> {
  final BasicUserRepository repository;

  GetBasicUser(this.repository);

  @override
  Future<Either<Failure, BasicUser>> call(NoParams params) async {
    return await repository.getBasicUser();
  }
}
