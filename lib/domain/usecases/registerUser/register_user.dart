import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/domain/entities/user_details.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/registerUser/register_user_repository.dart';

class RegisterUser extends Usecase<UserDetails, RegisterUserParams> {
  final RegisterUserRepository repository;

  RegisterUser(this.repository);

  @override
  Future<Either<Failure, UserDetails>> call(RegisterUserParams params) async {
    return await repository.registerUser(
      name: params.name,
      cityId: params.cityId,
      areaId: params.areaId,
    );
  }
}

class ActivateReferral extends Usecase<void, ActivateReferralParams> {
  final RegisterUserRepository repository;

  ActivateReferral(this.repository);

  @override
  Future<Either<Failure, void>> call(ActivateReferralParams params) async {
    return await repository.activateReferral(
      referralCode: params.referralCode,
      userId: params.userId,
    );
  }
}

class RegisterUserParams extends Equatable {
  final String name;
  final String cityId;
  final String areaId;

  RegisterUserParams({
    @required this.name,
    @required this.cityId,
    @required this.areaId,
  });

  @override
  List<Object> get props => [
        name,
        cityId,
        areaId,
      ];
}

class ActivateReferralParams extends Equatable {
  final String referralCode;
  final String userId;

  ActivateReferralParams({
    @required this.referralCode,
    @required this.userId,
  });

  @override
  List<Object> get props => [referralCode, userId];
}
