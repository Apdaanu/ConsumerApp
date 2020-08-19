import 'dart:convert';

import 'package:freshOk/core/error/exceptions.dart';
import 'package:freshOk/data/datasources/login/basic_user_local_datasource.dart';
import 'package:freshOk/data/models/basic_user_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  BasicUserLocalDatasourceImpl datasource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    datasource =
        BasicUserLocalDatasourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getBasicUser', () {
    final tBasicUserModel =
        BasicUserModel.fromJson(json.decode(fixture('basic_user_cache.json')));
    test(
      'should return BasicUser from sharedPreferences when there is one in the cache',
      () async {
        //arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('basic_user_cache.json'));
        //act
        final result = await datasource.getBasicUser();
        //assert
        verify(mockSharedPreferences.getString(CACHED_BASIC_USER));
        expect(result, equals(tBasicUserModel));
      },
    );
    test(
      'should throw CacheException when there is not a cached value',
      () async {
        //arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        //act
        final call = datasource.getBasicUser;
        //assert
        expect(() => call(), throwsA(isInstanceOf<CacheException>()));
      },
    );
  });

  group('cacheBasicUser', () {
    final tBasicUserModel = BasicUserModel(newUser: false, mob: 123);
    test(
      'should call SharedPreferences to cache the data',
      () async {
        //act
        datasource.cacheBasicUser(tBasicUserModel);
        //assert
        final expectedJsonString = json.encode(tBasicUserModel.toJson());
        verify(mockSharedPreferences.setString(
          CACHED_BASIC_USER,
          expectedJsonString,
        ));
      },
    );
  });
}
