import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/constants/connection.dart';
import 'package:freshOk/core/error/exceptions.dart';
import 'package:freshOk/core/token/token_provider.dart';
import 'package:freshOk/data/models/user_details_model.dart';
import 'package:http/http.dart' as http;

abstract class UserDetailsRemoteDatasource {
  Future<UserDetailsModel> getUserDetails();

  Future<UserDetailsModel> updateUserDetails({
    @required String name,
    @required String address,
    @required String cityId,
    @required String areaId,
    @required String landmark,
    @required String pin,
    @required String imageUrl,
  });
}

class UserDetailsRemoteDatasourceImpl implements UserDetailsRemoteDatasource {
  final http.Client client;
  final TokenProvider tokenProvider;

  UserDetailsRemoteDatasourceImpl({
    @required this.client,
    @required this.tokenProvider,
  });

  @override
  Future<UserDetailsModel> getUserDetails() async {
    final token = await tokenProvider.getToken();
    final response = await client.get(
      Connection.endpoint + '/api/customer',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return UserDetailsModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserDetailsModel> updateUserDetails({
    @required String name,
    @required String address,
    @required String cityId,
    @required String areaId,
    @required String landmark,
    @required String pin,
    @required String imageUrl,
  }) async {
    final token = await tokenProvider.getToken();
    final body = {
      'name': name,
      'address': address,
      'cityId': cityId,
      'areaId': areaId,
      'landmark': landmark,
      'pin': pin,
      'profilePhoto': imageUrl,
    };

    final response = await client.put(
      Connection.endpoint + '/api/customer',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      return UserDetailsModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
