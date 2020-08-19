part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class ChatSendEvent extends ChatEvent {
  @override
  List<Object> get props => [];
}

class ChatInitEvent extends ChatEvent {
  final String userId;

  ChatInitEvent(this.userId);

  @override
  List<Object> get props => [userId];
}
