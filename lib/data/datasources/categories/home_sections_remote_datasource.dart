import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/constants/connection.dart';
import 'package:freshOk/core/error/exceptions.dart';
import 'package:freshOk/core/token/token_provider.dart';
import 'package:freshOk/data/models/categories/category_model.dart';
import 'package:http/http.dart' as http;

abstract class HomeSectionRemoteDatasource {
  Future<List<dynamic>> getSections(String userId);
}

class HomeSectionRemoteDatasourceImpl implements HomeSectionRemoteDatasource {
  final http.Client client;
  final TokenProvider tokenProvider;

  HomeSectionRemoteDatasourceImpl({
    @required this.client,
    @required this.tokenProvider,
  });

  @override
  Future<List> getSections(String userId) async {
    final token = await tokenProvider.getToken();
    final response = await client.get(
      Connection.endpoint + '/api/customer/$userId/section',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      List<dynamic> sections =
          decoded.map((item) => CategoryModel.fromJson(item)).toList();
      return sections;
    } else {
      throw ServerException();
    }
  }
}
