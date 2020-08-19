import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/connection.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/token/token_provider.dart';
import '../../models/categories/product_model.dart';
import '../../models/categories/recepie_model.dart';
import '../../models/categories/search_response_model.dart';

abstract class ProductRemoteDatasource {
  Future<List> getProducts({
    @required String userId,
    @required String sectionId,
    @required String categoryId,
    @required String type,
  });

  Future<List> getSuggestions(String userId);

  Future<List> searchProducts(String search);

  Future<List> getProductsBasedOnSearch(String categoryId);
}

class ProductRemoteDatasourceImpl implements ProductRemoteDatasource {
  final http.Client client;
  final TokenProvider tokenProvider;

  ProductRemoteDatasourceImpl({
    @required this.client,
    @required this.tokenProvider,
  });

  @override
  Future<List> getProducts({
    @required String userId,
    @required String sectionId,
    @required String categoryId,
    @required String type,
  }) async {
    final token = await tokenProvider.getToken();
    final response = await client.get(
      Connection.endpoint +
          '/api/customer/$userId/section/$sectionId/$type/$categoryId',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      List<dynamic> products;
      if (type == 'productCategory')
        products =
            decoded.map((product) => ProductModel.fromJson(product)).toList();
      else
        products =
            decoded.map((product) => RecepieModel.fromJson(product)).toList();
      return products;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List> getSuggestions(String userId) async {
    final token = await tokenProvider.getToken();
    final response = await client.get(
      Connection.endpoint + '/api/customer/$userId/suggestions',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> products =
          decoded.map((product) => ProductModel.fromJson(product)).toList();
      return products;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List> searchProducts(String search) async {
    final token = await tokenProvider.getToken();
    final response = await client.get(
      Connection.endpoint + '/api/customerMixedSearch?searchValue=$search',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    print('[dbg] : ${response.body}');
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> searchRes =
          decoded.map((res) => SearchResponseModel.fromJson(res)).toList();
      return searchRes;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List> getProductsBasedOnSearch(String categoryId) async {
    final token = await tokenProvider.getToken();
    final response = await client.get(
      Connection.endpoint + '/api/customerproducts?categoryId=$categoryId',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      List<dynamic> products =
          decoded.map((product) => ProductModel.fromJson(product)).toList();
      return products;
    } else {
      throw ServerException();
    }
  }
}
