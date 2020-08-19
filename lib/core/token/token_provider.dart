import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class TokenProvider {
  Future<String> getToken();
  Future<void> setToken(String token);
  Future<void> removeToken();
}

const TOKEN = 'token';

class TokenProviderImpl implements TokenProvider {
  final FlutterSecureStorage storage;

  TokenProviderImpl({
    @required this.storage,
  });

  @override
  Future<String> getToken() async {
    final token = await storage.read(key: TOKEN);
    return token;
  }

  @override
  Future<void> setToken(String token) async {
    await storage.write(key: TOKEN, value: token);
  }

  @override
  Future<void> removeToken() async {
    await storage.delete(key: TOKEN);
  }
}
