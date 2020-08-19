import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/chat/chat_repository.dart';

class SendFeedback implements Usecase<void, SendFeedbackParams> {
  final ChatRepository repository;

  SendFeedback(this.repository);

  @override
  Future<Either<Failure, void>> call(SendFeedbackParams params) async {
    return await repository.sendFeedback(type: params.query, desc: params.desc);
  }
}

class SendFeedbackParams extends Equatable {
  final String query;
  final String desc;

  SendFeedbackParams(this.query, this.desc);

  @override
  List<Object> get props => [query, desc];
}
