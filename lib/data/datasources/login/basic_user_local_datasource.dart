import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/exceptions.dart';
import '../../models/basic_user_model.dart';

abstract class BasicUserLocalDatasource {
  ///Gets the cached [BasicUserModel]
  ///
  ///Throws [CacheException] for all errors
  Future<BasicUserModel> getBasicUser();

  Future<void> cacheBasicUser(BasicUserModel basicUserToCache);
}

const CACHED_BASIC_USER = 'CACHED_BASIC_USER';

class BasicUserLocalDatasourceImpl implements BasicUserLocalDatasource {
  final SharedPreferences sharedPreferences;

  BasicUserLocalDatasourceImpl({
    @required this.sharedPreferences,
  });

  @override
  Future<BasicUserModel> getBasicUser() {
    final jsonString = sharedPreferences.getString(CACHED_BASIC_USER);
    if (jsonString != null) {
      return Future.value(BasicUserModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheBasicUser(BasicUserModel basicUserToCache) {
    final jsonString = json.encode(basicUserToCache.toJson());
    return sharedPreferences.setString(
      CACHED_BASIC_USER,
      jsonString,
    );
  }
}
