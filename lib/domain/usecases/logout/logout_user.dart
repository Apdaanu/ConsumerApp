import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/constants/routes.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/repositories/logout/logout_repository.dart';
import 'package:freshOk/main.dart';

class LogoutUser implements Usecase<void, NoParams> {
  final LogoutRepository repository;

  LogoutUser(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    final failureOrVoid = await repository.logout();
    failureOrVoid.fold(
      (failure) {
        print('[sys] : logout failed');
      },
      (voidRes) {
        print('[sys] : User logged out susscesfully');
        navigatorKey.currentState.pushNamedAndRemoveUntil(
          rootRoute,
          ModalRoute.withName(homeRoute),
        );
      },
    );
    return Right(null);
  }
}
