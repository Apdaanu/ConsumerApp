import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:freshOk/core/error/failure.dart';

abstract class ChatRepository {
  Future<Either<Failure, List>> getChatMessages(String userId);

  Future<Either<Failure, void>> sendChatMessage({
    @required String userId,
    @required String message,
  });

  Future<Either<Failure, void>> sendFeedback({
    type,
    String desc,
  });
}
