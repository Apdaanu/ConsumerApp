import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/constants/connection.dart';
import 'package:freshOk/core/error/exceptions.dart';
import 'package:freshOk/core/token/token_provider.dart';
import 'package:freshOk/data/models/chat/chat_model.dart';
import 'package:http/http.dart' as http;

abstract class ChatRemoteDatasource {
  Future<List> getChatMessages(String userId);

  Future<void> sendChatMessage({
    @required String userId,
    @required String message,
  });

  Future<void> sendFeedback({type, String desc});
}

class ChatRemoteDatasourceImpl implements ChatRemoteDatasource {
  final http.Client client;
  final TokenProvider tokenProvider;

  ChatRemoteDatasourceImpl({
    @required this.client,
    @required this.tokenProvider,
  });

  @override
  Future<List> getChatMessages(String userId) async {
    final String token = await tokenProvider.getToken();
    final response = await client.get(
      Connection.endpoint + '/api/customer/$userId/chat',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List chats =
          decoded['messages'].map((chat) => ChatModel.fromJson(chat)).toList();
      return chats;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> sendChatMessage({String userId, String message}) async {
    final String token = await tokenProvider.getToken();
    final response = await client.post(
      Connection.endpoint + '/api/customer/$userId/chat',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: json.encode(
        {
          'message': message,
        },
      ),
    );
    print('[dbg] : ${response.statusCode}');
    print('[dbg] : ${response.body}');
    if (response.statusCode == 200) {
      return null;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> sendFeedback({type, String desc}) async {
    final String token = await tokenProvider.getToken();
    var body = {"type": type.toString(), "desc": desc};
    final response = await http.post(
      Connection.endpoint + '/api/report',
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        HttpHeaders.contentTypeHeader: "application/json"
      },
      body: json.encode(body),
    );
    print('[dbg] : ${response.body}');
    if (response.statusCode == 200) {
      return null;
    } else {
      throw ServerException();
    }
  }
}
