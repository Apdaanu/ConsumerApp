import 'dart:convert';
import 'dart:io';
import 'package:freshOk/core/constants/connection.dart';
import 'package:freshOk/core/error/exceptions.dart';
import 'package:freshOk/core/token/token_provider.dart';
import 'package:freshOk/data/datasources/login/otp_handler_remote_datasource.dart';
import 'package:freshOk/data/models/basic_user_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockTokenProvider extends Mock implements TokenProvider {}

void main() {
  OtpHandlerRemoteDatasourceImpl datasource;
  MockHttpClient mockHttpClient;
  MockTokenProvider mockTokenProvider;

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockTokenProvider = MockTokenProvider();
    datasource = OtpHandlerRemoteDatasourceImpl(
      client: mockHttpClient,
      tokenProvider: mockTokenProvider,
    );
  });

  group('sendOtp', () {
    final tMob = 123;
    test(
      '''should perform a post request on url''',
      () async {
        //arrange
        when(mockHttpClient.post(
          Connection.endpoint + '/api/user/otp',
          body: json.encode({
            "mob": tMob,
          }),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        )).thenAnswer((realInvocation) async => http.Response('OK', 200));
        //act
        await datasource.sendOtp(tMob);
        //assert
        verify(mockHttpClient.post(
          Connection.endpoint + '/api/user/otp',
          body: json.encode({
            "mob": tMob,
          }),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ));
      },
    );

    test(
      '''should return true on response.status 200''',
      () async {
        //arrange
        when(mockHttpClient.post(
          Connection.endpoint + '/api/user/otp',
          body: json.encode({
            "mob": tMob,
          }),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        )).thenAnswer((realInvocation) async => http.Response('OK', 200));
        //act
        final result = await datasource.sendOtp(tMob);
        //assert
        expect(result, equals(true));
      },
    );

    test(
      '''should return ServerException on response.status != 200''',
      () async {
        //arrange
        when(mockHttpClient.post(
          Connection.endpoint + '/api/user/otp',
          body: json.encode({
            "mob": tMob,
          }),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        )).thenAnswer((realInvocation) async => http.Response('OK', 404));
        //act
        final call = datasource.sendOtp;
        //assert
        expect(() => call(tMob), throwsA(isInstanceOf<ServerException>()));
      },
    );
  });

  group('verifyOtp', () {
    final tMob = 123;
    final tOtp = 1234;
    final tStatus = 'customer';
    final verifiedOtpTrueJson = fixture('verify_otp_true.json');
    final verifiedOtpFalseJson = fixture('verify_otp_false.json');
    final postBody = json.encode({
      "mob": tMob,
      "otp": tOtp,
      "status": tStatus,
    });
    final tBasicUser = BasicUserModel(mob: tMob, newUser: true);

    void mockOtpResponseTrue() {
      when(mockHttpClient.post(
        Connection.endpoint + '/api/user/otp/verify',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: postBody,
      )).thenAnswer(
          (realInvocation) async => http.Response(verifiedOtpTrueJson, 200));
    }

    void mockOtpResponseFalse() {
      when(mockHttpClient.post(
        Connection.endpoint + '/api/user/otp/verify',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: postBody,
      )).thenAnswer(
          (realInvocation) async => http.Response(verifiedOtpFalseJson, 200));
    }

    void mockOtpFailure() {
      when(mockHttpClient.post(
        Connection.endpoint + '/api/user/otp/verify',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: postBody,
      )).thenAnswer(
          (realInvocation) async => http.Response('Error Message', 404));
    }

    test(
      'should perform a post request on /api/user/otp/verify',
      () async {
        //arrange
        mockOtpResponseTrue();
        //act
        await datasource.verifyOtp(mob: tMob, otp: tOtp, status: tStatus);
        //assert
        verify(mockHttpClient.post(
          Connection.endpoint + '/api/user/otp/verify',
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: postBody,
        ));
      },
    );

    test(
      'should throw ServerException when status code != 200',
      () async {
        //arrange
        mockOtpFailure();
        //act
        final call = datasource.verifyOtp;
        //assert
        expect(() => call(mob: tMob, otp: tOtp, status: tStatus),
            throwsA(isInstanceOf<ServerException>()));
      },
    );

    group('when statuscode == 200', () {
      test(
        'should throw VerificationException when verified == false in response',
        () async {
          //arrange
          mockOtpResponseFalse();
          //act
          final call = datasource.verifyOtp;
          //assert
          expect(() => call(mob: tMob, otp: tOtp, status: tStatus),
              throwsA(isInstanceOf<VerificationException>()));
        },
      );

      test(
        'should return BasicUserModel when verified == true in response',
        () async {
          //arrange
          mockOtpResponseTrue();
          //act
          final result =
              await datasource.verifyOtp(mob: tMob, otp: tOtp, status: tStatus);
          //assert
          expect(result, equals(tBasicUser));
        },
      );

      test(
        'should cache the token when verified',
        () async {
          //arrange
          mockOtpResponseTrue();
          when(mockTokenProvider.setToken(any))
              .thenAnswer((realInvocation) async => null);
          //act
          await datasource.verifyOtp(mob: tMob, otp: tOtp, status: tStatus);
          //assert
          verify(mockTokenProvider.setToken('test_token'));
        },
      );
    });
  });
}
