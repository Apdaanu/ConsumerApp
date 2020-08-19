import 'dart:convert';
import 'dart:io';

import 'package:freshOk/core/constants/connection.dart';
import 'package:freshOk/core/error/exceptions.dart';
import 'package:freshOk/core/token/token_provider.dart';
import 'package:freshOk/data/datasources/login/basic_user_remote_datasource.dart';
import 'package:freshOk/data/models/basic_user_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockTokenProvider extends Mock implements TokenProvider {}

void main() {
  BasicUserRemoteDatasourceImpl datasource;
  MockHttpClient mockHttpClient;
  MockTokenProvider mockTokenProvider;

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockTokenProvider = MockTokenProvider();
    datasource = BasicUserRemoteDatasourceImpl(
      client: mockHttpClient,
      tokenProvider: mockTokenProvider,
    );
  });
  final tToken = 'test_token';

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(fixture('basic_user.json'), 200));
  }

  void setUpMockHttpClientFailure() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  void setUpMockTokenProvider() {
    when(mockTokenProvider.getToken()).thenAnswer((_) async => tToken);
  }

  void setUpMockTokenProviderNull() {
    when(mockTokenProvider.getToken()).thenAnswer((_) async => null);
  }

  group('getBasicUser', () {
    final tBasicUserModel =
        BasicUserModel.fromJson(json.decode(fixture('basic_user.json')));
    test(
      '''should perform a get request on a url with headers:
          appplication/json,
          bearer token
      ''',
      () async {
        //arrange
        setUpMockHttpClientSuccess200();
        setUpMockTokenProvider();
        //act
        await datasource.getBasicUser();
        //assert
        verify(mockHttpClient.get(
          Connection.endpoint + '/api/getUser',
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $tToken',
          },
        ));
      },
    );

    test(
      'should return basic user when the response code in 200',
      () async {
        //arrange
        setUpMockHttpClientSuccess200();
        setUpMockTokenProvider();
        //act
        final result = await datasource.getBasicUser();
        //assert
        expect(result, equals(tBasicUserModel));
      },
    );

    test(
      'should throw a ServerException when the response code is not 200',
      () async {
        //arrange
        setUpMockHttpClientFailure();
        setUpMockTokenProvider();
        //act
        final call = datasource.getBasicUser;
        //assert
        expect(() => call(), throwsA(isInstanceOf<ServerException>()));
      },
    );

    group('should throw a CacheException when the token is null', () {
      test(
        'should throw a CacheException when the response code is 200',
        () async {
          //arrange
          setUpMockHttpClientSuccess200();
          setUpMockTokenProviderNull();
          //act
          final call = datasource.getBasicUser;
          //assert
          expect(() => call(), throwsA(isInstanceOf<CacheException>()));
        },
      );

      test(
        'should throw a CacheException when the response code is not 200',
        () async {
          //arrange
          setUpMockHttpClientFailure();
          setUpMockTokenProviderNull();
          //act
          final call = datasource.getBasicUser;
          //assert
          expect(() => call(), throwsA(isInstanceOf<CacheException>()));
        },
      );
    });
  });
}
