import 'package:flutter/foundation.dart';
import 'package:freshOk/domain/entities/chat/chat.dart';

class ChatModel extends Chat {
  ChatModel({
    @required String status,
    @required String message,
  }) : super(
          status: status,
          message: message,
        );
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      status: json['status'],
      message: json['message'],
    );
  }
}
