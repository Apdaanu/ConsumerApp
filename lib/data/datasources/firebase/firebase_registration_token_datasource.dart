import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/constants/connection.dart';
import 'package:freshOk/core/error/exceptions.dart';
import 'package:freshOk/core/token/token_provider.dart';
import 'package:http/http.dart' as http;

abstract class FirebaseRegistrationTokenDatasource {
  Future<void> postToken({
    @required String userId,
    @required String token,
  });
}

class FirebaseRegistrationTokenDatasourceImpl
    implements FirebaseRegistrationTokenDatasource {
  final http.Client client;
  final TokenProvider tokenProvider;

  FirebaseRegistrationTokenDatasourceImpl({
    @required this.client,
    @required this.tokenProvider,
  });

  @override
  Future<void> postToken({String userId, String token}) async {
    final token = await tokenProvider.getToken();
    final body = {'firebaseRegistrationToken': token};
    final response = await client.put(
      Connection.endpoint + '/api/customer/$userId/firebaseRegistrationToken',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      return null;
    } else {
      throw ServerException();
    }
  }
}
