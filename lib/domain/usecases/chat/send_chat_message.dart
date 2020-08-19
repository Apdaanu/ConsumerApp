import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/repositories/chat/chat_repository.dart';

class SendChatMessage implements Usecase<void, SendChatParams> {
  final ChatRepository repository;

  SendChatMessage(this.repository);

  @override
  Future<Either<Failure, void>> call(SendChatParams params) async {
    return await repository.sendChatMessage(
      message: params.message,
      userId: params.userId,
    );
  }
}

class SendChatParams extends Equatable {
  final String userId;
  final String message;

  SendChatParams({
    @required this.userId,
    @required this.message,
  });

  @override
  List<Object> get props => [];
}
