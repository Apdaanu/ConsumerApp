import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/domain/repositories/login/otp_handler_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';

class SendOtp implements Usecase<bool, Params> {
  final OtpHandlerRepository repository;

  SendOtp(this.repository);

  @override
  Future<Either<Failure, bool>> call(Params params) async {
    return await repository.sendOtp(params.mob);
  }
}

class Params extends Equatable {
  final int mob;

  Params({
    @required this.mob,
  });

  @override
  List<Object> get props => [mob];
}
