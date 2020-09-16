import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/connection.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/token/token_provider.dart';
import '../../models/categories/category_model.dart';
import '../../models/categories/recepie_model.dart';
import '../../models/categories/search_response_model.dart';
import '../../models/categories/type_category_model.dart';

abstract class RecepieRemoteDatasource {
  Future<List> getRecepieSections(String userId);

  Future<List> getRecepies({
    @required String userId,
    @required String sectionId,
    @required String categoryId,
    @required String type,
  });

  Future<List> getAllRecepies();

  Future<RecepieModel> getRecepieDetails(String recepieId);

  Future<List> getMyRecepies(String userId);

  Future<List> getLikedRecepies(String userId);

  Future<void> likeRecepie({
    @required String recepieId,
    @required String userId,
  });

  Future<List> getDishTypes();

  Future<List> getCuisinesTypes();

  Future<List> searchRecepies(String search);
}

class RecepieRemoteDatasourceImpl implements RecepieRemoteDatasource {
  final http.Client client;
  final TokenProvider tokenProvider;

  RecepieRemoteDatasourceImpl({
    @required this.client,
    @required this.tokenProvider,
  });

  @override
  Future<List> getRecepieSections(String userId) async {
    final String token = await tokenProvider.getToken();
    final response = await client.get(
      Connection.endpoint + '/api/customer/$userId/recipeSection',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    print('[dbg] : ${response.statusCode}');
    print('[dbg] : ${response.body}');
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List sections = decoded.map((category) => CategoryModel.fromJson(category)).toList();
      return sections;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List> getAllRecepies() async {
    final String token = await tokenProvider.getToken();
    final response = await client.get(
      Connection.endpoint + '/api/recipe',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List recepies = decoded.map((recepie) => RecepieModel.fromJson(recepie)).toList();
      return recepies;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List> getMyRecepies(String userId) async {
    final String token = await tokenProvider.getToken();
    final response = await client.get(
      Connection.endpoint + '/api/customer/$userId/recipe',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List recepies = decoded.map((recepie) => RecepieModel.fromJson(recepie)).toList();
      return recepies;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List> getLikedRecepies(String userId) async {
    final String token = await tokenProvider.getToken();
    final response = await client.get(
      Connection.endpoint + '/api/customer/$userId/likedRecipe',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List recepies = decoded.map((recepie) => RecepieModel.fromJson(recepie)).toList();
      return recepies;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<RecepieModel> getRecepieDetails(String recepieId) async {
    final String token = await tokenProvider.getToken();
    final response = await client.get(
      Connection.endpoint + '/api/recipe/$recepieId',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final RecepieModel recepieModel = RecepieModel.fromJson(decoded);
      return recepieModel;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List> getRecepies({
    String userId,
    String sectionId,
    String categoryId,
    String type,
  }) async {
    final String token = await tokenProvider.getToken();
    final response = await client.get(
      Connection.endpoint + '/api/customer/$userId/recipeSection/$sectionId/$type/$categoryId',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List recepies = decoded.map((recepie) => RecepieModel.fromJson(recepie)).toList();
      return recepies;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> likeRecepie({
    String recepieId,
    String userId,
  }) async {
    final String token = await tokenProvider.getToken();
    final response = await client.put(
      Connection.endpoint + '/api/recipe/$recepieId/like',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: json.encode({'userId': userId}),
    );
    if (response.statusCode == 200) {
      return null;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List> getDishTypes() async {
    final String token = await tokenProvider.getToken();
    final response = await client.get(
      Connection.endpoint + '/api/recipeCategory',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List dishTypes = decoded.map((type) => TypeCategoryModel.fromJson(type)).toList();
      return dishTypes;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List> getCuisinesTypes() async {
    final String token = await tokenProvider.getToken();
    final response = await client.get(
      Connection.endpoint + '/api/cuisine',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List dishTypes = decoded.map((type) => TypeCategoryModel.fromJson(type)).toList();
      return dishTypes;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List> searchRecepies(String search) async {
    final String token = await tokenProvider.getToken();
    final response = await client.get(
      Connection.endpoint + '/api/recipe?searchValue=$search',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List searchRes = decoded.map((recepie) => SearchResponseModel.fromJson(recepie)).toList();
      return searchRes;
    } else {
      throw ServerException();
    }
  }
}
