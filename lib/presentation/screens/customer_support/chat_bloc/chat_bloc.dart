import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../../core/token/token_provider.dart';
import '../../../../domain/usecases/chat/get_chat_messages.dart';
import '../../../../domain/usecases/chat/send_chat_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatMessages getChatMessages;
  final SendChatMessage sendChatMessage;
  final TokenProvider tokenProvider;

  ChatBloc({
    @required this.getChatMessages,
    @required this.tokenProvider,
    @required this.sendChatMessage,
  }) : super(ChatInitial());

  String userId;
  List<dynamic> messages;
  double height, width;
  ScrollController scrollController;
  IO.Socket socket;

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is ChatInitEvent) {}
    if (event is ChatSendEvent) {
      // print('[dbg] : ${controller.text}');
      await sendChatMessage(
        SendChatParams(
          userId: this.userId,
          // message: controller.text,
        ),
      );
    }
  }
}
