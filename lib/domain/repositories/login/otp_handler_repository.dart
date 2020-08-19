import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../entities/basic_user.dart';

abstract class OtpHandlerRepository {
  Future<Either<Failure, bool>> sendOtp(int mob);

  Future<Either<Failure, BasicUser>> verifyOtp({
    int mob,
    int otp,
    String status,
  });
}
