import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/error/exceptions.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/connection.dart';
import '../../../core/token/token_provider.dart';
import '../../models/referral/referral_model.dart';

abstract class ReferralRemoteDatasource {
  Future<ReferralModel> getReferrals();

  Future<double> getFreshOkCredits(String userId);
}

class ReferralRemoteDatasourceImpl implements ReferralRemoteDatasource {
  final http.Client client;
  final TokenProvider tokenProvider;

  ReferralRemoteDatasourceImpl({
    @required this.client,
    @required this.tokenProvider,
  });

  @override
  Future<ReferralModel> getReferrals() async {
    final token = await tokenProvider.getToken();
    final response = await client.get(
      Connection.endpoint + '/api/user/referrals',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return ReferralModel.fromJson(decoded);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<double> getFreshOkCredits(String userId) async {
    final token = await tokenProvider.getToken();
    final response = await client.get(
      Connection.endpoint + '/api/customer/$userId/credits',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded.toDouble();
    } else {
      throw ServerException();
    }
  }
}
