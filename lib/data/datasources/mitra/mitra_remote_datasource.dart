import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/constants/connection.dart';
import 'package:freshOk/core/error/exceptions.dart';
import 'package:freshOk/core/token/token_provider.dart';
import 'package:freshOk/data/models/mitra/mitra_model.dart';
import 'package:http/http.dart' as http;

abstract class MitraRemoteDatasource {
  Future<List> getMitras(String userId);

  Future<void> setMitra({
    @required String mitraId,
    @required String userId,
  });
}

class MitraRemoteDatasourceImpl implements MitraRemoteDatasource {
  final http.Client client;
  final TokenProvider tokenProvider;

  MitraRemoteDatasourceImpl({
    @required this.client,
    @required this.tokenProvider,
  });

  @override
  Future<List> getMitras(String userId) async {
    final String token = await tokenProvider.getToken();
    final response = await client.get(
      Connection.endpoint + '/api/customer/$userId/mitralist',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List mitras =
          decoded.map((mitra) => MitraModel.fromJson(mitra)).toList();
      return mitras;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> setMitra({
    String mitraId,
    String userId,
  }) async {
    final String token = await tokenProvider.getToken();
    final body = {'mitraId': mitraId};
    final response = await client.put(
      Connection.endpoint + '/api/customer/$userId/mitra',
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
