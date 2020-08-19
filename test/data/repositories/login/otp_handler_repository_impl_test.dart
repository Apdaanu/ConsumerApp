import 'package:dartz/dartz.dart';
import 'package:freshOk/core/error/exceptions.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:freshOk/core/netowrk/network_info.dart';
import 'package:freshOk/data/datasources/login/basic_user_local_datasource.dart';
import 'package:freshOk/data/datasources/login/otp_handler_remote_datasource.dart';
import 'package:freshOk/data/models/basic_user_model.dart';
import 'package:freshOk/data/repositories/login/otp_handler_repository_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDatasource extends Mock implements OtpHandlerRemoteDatasource {}

class MockLocalDatasource extends Mock implements BasicUserLocalDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  OtpHandlerRepositoryImpl repository;
  MockRemoteDatasource mockRemoteDatasource;
  MockLocalDatasource mockLocalDatasource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDatasource = MockRemoteDatasource();
    mockLocalDatasource = MockLocalDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repository = OtpHandlerRepositoryImpl(
      localDatasource: mockLocalDatasource,
      networkInfo: mockNetworkInfo,
      remoteDatasource: mockRemoteDatasource,
    );
  });

  void mockNetworkInfoSetUp(val) {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => val);
  }

  final tBasicUserModel = BasicUserModel(mob: 123, newUser: false);
  final tBasicUser = tBasicUserModel;

  group('sendOtp', () {
    final tMob = 123;
    test(
      'should check if the device is online',
      () async {
        //arrange
        mockNetworkInfoSetUp(true);
        //act
        repository.sendOtp(tMob);
        //assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        mockNetworkInfoSetUp(true);
      });
      test(
        'should send the otp',
        () async {
          //arrange
          when(mockRemoteDatasource.sendOtp(any)).thenAnswer((_) async => true);
          //act
          repository.sendOtp(tMob);
          //assert
          verify(mockRemoteDatasource.sendOtp(tMob));
        },
      );

      test(
        'should return true if otp succesfully sent',
        () async {
          //arrange
          when(mockRemoteDatasource.sendOtp(any)).thenAnswer((_) async => true);
          //act
          final result = await repository.sendOtp(tMob);
          //assert
          expect(result, equals(Right(true)));
        },
      );

      test(
        'should return server failure when the call server is unsuccessfull',
        () async {
          //arrange
          when(mockRemoteDatasource.sendOtp(any)).thenThrow(ServerException());
          //act
          final result = await repository.sendOtp(tMob);
          //assert
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        mockNetworkInfoSetUp(false);
      });

      test(
        'should return Connectionfailure when not connected to internet',
        () async {
          //act
          final result = await repository.sendOtp(tMob);
          //assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });

  group('verifyOtp', () {
    test(
      'should return BasicUser on successful verification of Otp',
      () async {
        //arrange
        when(mockRemoteDatasource.verifyOtp(
                mob: anyNamed('mob'),
                otp: anyNamed('otp'),
                status: anyNamed('status')))
            .thenAnswer((realInvocation) async => tBasicUserModel);
        //act
        final result =
            await repository.verifyOtp(mob: 123, otp: 1234, status: 'customer');
        //assert
        verify(mockRemoteDatasource.verifyOtp(
            mob: 123, otp: 1234, status: 'customer'));
        expect(result, equals(Right(tBasicUser)));
      },
    );

    test(
      'should cache BasicUser on successful verification',
      () async {
        //act
        await repository.verifyOtp(mob: 123, otp: 1234, status: 'customer');
        //assert
        verify(mockLocalDatasource.cacheBasicUser(any));
      },
    );

    test(
      'should return VerificationFailure on verification failed',
      () async {
        //arrange
        when(mockRemoteDatasource.verifyOtp(
                mob: anyNamed('mob'),
                otp: anyNamed('otp'),
                status: anyNamed('status')))
            .thenThrow(VerificationException());
        //act
        final result =
            await repository.verifyOtp(mob: 123, otp: 1234, status: 'customer');
        //assert
        expect(result, equals(Left(VerificationFailure())));
      },
    );

    test(
      'should return ServerFailure on server failure',
      () async {
        //arrange
        when(mockRemoteDatasource.verifyOtp(
                mob: anyNamed('mob'),
                otp: anyNamed('otp'),
                status: anyNamed('status')))
            .thenThrow(ServerException());
        //act
        final result =
            await repository.verifyOtp(mob: 123, otp: 1234, status: 'customer');
        //assert
        expect(result, equals(Left(ServerFailure())));
      },
    );
  });
}
