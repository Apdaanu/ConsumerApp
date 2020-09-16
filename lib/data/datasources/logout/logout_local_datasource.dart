import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/token/token_provider.dart';
import '../../../domain/usecases/services/dynamic_link_service.dart';
import '../login/basic_user_local_datasource.dart';
import '../orders/cart_local_datasource.dart';
import '../user_details/user_details_local_datasource.dart';

abstract class LogoutLocalDatasource {
  Future<void> logout();
}

class LogoutLocalDatasourceImpl implements LogoutLocalDatasource {
  final FlutterSecureStorage flutterSecureStorage;
  final SharedPreferences sharedPreferences;

  LogoutLocalDatasourceImpl({
    @required this.flutterSecureStorage,
    @required this.sharedPreferences,
  });

  @override
  Future<void> logout() async {
    sharedPreferences.remove(CACHED_BASIC_USER);
    sharedPreferences.remove(CACHE_USER_DETAILS);
    sharedPreferences.remove(REFERRAL_CACHE);
    sharedPreferences.remove(CART_CACHE);
    sharedPreferences.remove(REFERRAL_CACHE);
    await flutterSecureStorage.delete(key: TOKEN);
    return null;
  }
}
