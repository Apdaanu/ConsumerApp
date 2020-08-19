import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freshOk/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_details_model.dart';

abstract class UserDetailsLocalDatasource {
  Future<UserDetailsModel> getUserDetails();
  Future<void> setUserDetails(UserDetailsModel userDetailsModel);
}

const CACHE_USER_DETAILS = 'CACHE_USER_DETAILS';

class UserDetailsLocalDatasourceImpl implements UserDetailsLocalDatasource {
  final SharedPreferences sharedPreferences;

  UserDetailsLocalDatasourceImpl({@required this.sharedPreferences});

  @override
  Future<UserDetailsModel> getUserDetails() {
    final jsonString = sharedPreferences.getString(CACHE_USER_DETAILS);
    if (jsonString != null) {
      return Future.value(UserDetailsModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> setUserDetails(UserDetailsModel userDetailsModel) {
    final jsonString = json.encode(userDetailsModel.toJson());
    return sharedPreferences.setString(
      CACHE_USER_DETAILS,
      jsonString,
    );
  }
}
