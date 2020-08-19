import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freshOk/core/token/token_provider.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/entities/basic_user.dart';
import 'package:freshOk/domain/repositories/login/basic_user_repository.dart';

class AuthenticationService implements Usecase<BasicUser, NoParams> {
  final BasicUserRepository repository;
  final TokenProvider tokenProvider;

  AuthenticationService({
    @required this.repository,
    @required this.tokenProvider,
  });

  @override
  Future<Either<Failure, BasicUser>> call(NoParams params) async {
    final token = await tokenProvider.getToken();
    if (token != null) {
      return await repository.getBasicUser();
    } else {
      return Left(AuthenticationFailure());
    }
  }
}
