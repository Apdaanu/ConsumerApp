import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/connection.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/token/token_provider.dart';
import '../../models/places/city_model.dart';

abstract class GetPlacesDatasource {
  Future<List<dynamic>> getPlaces();
}

class GetPlacesDatasourceImpl implements GetPlacesDatasource {
  final http.Client client;
  final TokenProvider tokenProvider;

  GetPlacesDatasourceImpl({
    @required this.client,
    @required this.tokenProvider,
  });

  @override
  Future<List<dynamic>> getPlaces() async {
    final token = await tokenProvider.getToken();
    final response = await client.get(
      Connection.endpoint + '/api/place',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      List<dynamic> places =
          decoded.map((city) => CityModel.fromJson(city)).toList();
      return places;
    } else {
      throw ServerException();
    }
  }
}
