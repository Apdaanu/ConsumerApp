import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../entities/basic_user.dart';

abstract class BasicUserRepository {
  Future<Either<Failure, BasicUser>> getBasicUser();
}
