import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:freshOk/core/token/token_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  TokenProviderImpl tokenProvider;
  MockFlutterSecureStorage mockFlutterSecureStorage;

  setUp(() {
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    tokenProvider = TokenProviderImpl(storage: mockFlutterSecureStorage);
  });

  final tToken = 'test_token';

  void setUpFlutterSecureStorageRead() {
    when(mockFlutterSecureStorage.read(key: anyNamed('key')))
        .thenAnswer((_) async => tToken);
  }

  group('getToken', () {
    test(
      'should provide token when there is one present',
      () async {
        //arrange
        setUpFlutterSecureStorageRead();
        //act
        final result = await tokenProvider.getToken();
        //assert
        verify(mockFlutterSecureStorage.read(key: TOKEN));
        expect(result, tToken);
      },
    );

    test(
      'should return null when no token is present',
      () async {
        //arrange
        when(mockFlutterSecureStorage.read(key: anyNamed('key')))
            .thenAnswer((_) async => null);
        //act
        final result = await tokenProvider.getToken();
        //assert
        expect(result, equals(null));
      },
    );
  });
  group('setToken', () {
    test(
      'should set a token value',
      () async {
        //arrange
        when(mockFlutterSecureStorage.write(
                key: anyNamed('key'), value: anyNamed('value')))
            .thenAnswer((_) async => tToken);
        //act
        await tokenProvider.setToken(tToken);
        //assert
        verify(mockFlutterSecureStorage.write(key: TOKEN, value: tToken));
      },
    );
  });
}
