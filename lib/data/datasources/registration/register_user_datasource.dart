import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:freshOk/data/datasources/user_details/user_details_local_datasource.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/connection.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/token/token_provider.dart';
import '../../models/user_details_model.dart';

abstract class RegisterUserDatasource {
  Future<UserDetailsModel> registerUser({
    @required String name,
    @required String cityId,
    @required String areaId,
  });

  Future<void> activateReferral({
    @required String referralCode,
    @required String userId,
  });
}

class RegisterUserDatasourceImpl implements RegisterUserDatasource {
  final http.Client client;
  final TokenProvider tokenProvider;

  RegisterUserDatasourceImpl(
      {@required this.client, @required this.tokenProvider});

  @override
  Future<UserDetailsModel> registerUser({
    @required String name,
    @required String cityId,
    @required String areaId,
  }) async {
    final token = await tokenProvider.getToken();
    final body = json.encode({
      "name": name,
      "cityId": cityId,
      "areaId": areaId,
    });
    final response = await client.post(
      Connection.endpoint + '/api/customer',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: body,
    );
    if (response.statusCode == 200) {
      return UserDetailsModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> activateReferral({
    @required String referralCode,
    @required String userId,
  }) async {
    final token = await tokenProvider.getToken();
    final body = {
      "referralCode": referralCode,
    };
    final response = await client.put(
      Connection.endpoint + '/api/customer/$userId/referred',
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
