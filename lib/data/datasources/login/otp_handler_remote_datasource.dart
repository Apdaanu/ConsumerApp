import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/connection.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/token/token_provider.dart';
import '../../models/basic_user_model.dart';

abstract class OtpHandlerRemoteDatasource {
  ///endpoint /api/user/otp
  ///
  ///throws [ServerException]
  Future<bool> sendOtp(int mob);

  ///endpoint /api/user/otp/verify
  ///
  ///throws [VerificationException] or [ServerException]
  Future<BasicUserModel> verifyOtp({
    @required int mob,
    @required int otp,
    @required String status,
  });
}

class OtpHandlerRemoteDatasourceImpl implements OtpHandlerRemoteDatasource {
  final http.Client client;
  final TokenProvider tokenProvider;

  OtpHandlerRemoteDatasourceImpl({
    @required this.client,
    @required this.tokenProvider,
  });

  @override
  Future<bool> sendOtp(int mob) async {
    final response = await client.post(
      Connection.endpoint + '/api/user/otp',
      body: json.encode({
        "mob": mob,
      }),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<BasicUserModel> verifyOtp({
    @required int mob,
    @required int otp,
    @required String status,
  }) async {
    final postBody = json.encode({
      "mob": mob,
      "otp": otp,
      "status": status,
    });
    final response = await client.post(
      Connection.endpoint + '/api/user/otp/verify',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: postBody,
    );
    print('[dbg] : ${response.statusCode}');

    print('[dbg] : ${response.body}');
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded['token'] != null) {
        final basicUser = BasicUserModel.fromJson(decoded);
        await tokenProvider.setToken(decoded['token']);
        return basicUser;
      } else {
        throw VerificationException();
      }
    } else if (response.statusCode == 403) {
      throw VerificationException();
    } else {
      throw ServerException();
    }
  }
}
