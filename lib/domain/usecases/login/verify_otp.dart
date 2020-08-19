import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/entities/basic_user.dart';
import 'package:freshOk/domain/repositories/login/otp_handler_repository.dart';

class VerifyOtp implements Usecase<BasicUser, Params> {
  final OtpHandlerRepository repository;

  VerifyOtp(this.repository);

  @override
  Future<Either<Failure, BasicUser>> call(Params params) async {
    return await repository.verifyOtp(
      mob: params.mob,
      otp: params.otp,
      status: params.status,
    );
  }
}

class Params extends Equatable {
  final int mob;
  final int otp;
  final String status;

  Params({
    @required this.mob,
    @required this.otp,
    @required this.status,
  });

  @override
  List<Object> get props => [mob, otp, status];
}
