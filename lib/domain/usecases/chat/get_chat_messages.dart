import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/repositories/chat/chat_repository.dart';

class GetChatMessages implements Usecase<List, ChatParams> {
  final ChatRepository repository;

  GetChatMessages(this.repository);

  @override
  Future<Either<Failure, List>> call(ChatParams params) async {
    return await repository.getChatMessages(params.userId);
  }
}

class ChatParams extends Equatable {
  final String userId;

  ChatParams(this.userId);

  @override
  List<Object> get props => [userId];
}
