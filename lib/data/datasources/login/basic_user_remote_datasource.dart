import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/connection.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/token/token_provider.dart';
import '../../models/basic_user_model.dart';

abstract class BasicUserRemoteDatasource {
  ///calls the /api/getUser endpoint
  ///
  ///Throws [server exception] for all errors
  Future<BasicUserModel> getBasicUser();
}

class BasicUserRemoteDatasourceImpl implements BasicUserRemoteDatasource {
  final http.Client client;
  final TokenProvider tokenProvider;

  BasicUserRemoteDatasourceImpl({
    @required this.client,
    @required this.tokenProvider,
  });

  @override
  Future<BasicUserModel> getBasicUser() async {
    final token = await tokenProvider.getToken();
    final response = await client.get(
      Connection.endpoint + '/api/getUser',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return BasicUserModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
