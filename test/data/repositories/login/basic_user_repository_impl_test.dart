import 'package:dartz/dartz.dart';
import 'package:freshOk/core/error/exceptions.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:freshOk/core/netowrk/network_info.dart';
import 'package:freshOk/data/datasources/login/basic_user_local_datasource.dart';
import 'package:freshOk/data/datasources/login/basic_user_remote_datasource.dart';
import 'package:freshOk/data/models/basic_user_model.dart';
import 'package:freshOk/data/repositories/login/basic_user_repository_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock implements BasicUserRemoteDatasource {}

class MockLocalDataSource extends Mock implements BasicUserLocalDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  BasicUserRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = BasicUserRepositoryImpl(
      remoteDatasource: mockRemoteDataSource,
      localDatasource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tBasicUserModel = BasicUserModel(mob: 123, newUser: false);
  final tBasicUser = tBasicUserModel;

  group('getBasicUser', () {
    test(
      'should check if the device is online',
      () async {
        //arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        //act
        repository.getBasicUser();

        //assert
        verify(mockNetworkInfo.isConnected);
      },
    );
  });

  group('device is online', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test(
      'should return basic user when connected to the internet',
      () async {
        //arrange
        when(mockRemoteDataSource.getBasicUser())
            .thenAnswer((_) async => tBasicUserModel);
        //act
        final result = await repository.getBasicUser();
        //assert
        verify(mockRemoteDataSource.getBasicUser());
        expect(result, equals(Right(tBasicUser)));
      },
    );

    test(
      'should cache the data locally when connected to the internet',
      () async {
        //arrange
        when(mockRemoteDataSource.getBasicUser())
            .thenAnswer((_) async => tBasicUserModel);
        //act
        await repository.getBasicUser();
        //assert
        verify(mockRemoteDataSource.getBasicUser());
        verify(mockLocalDataSource.cacheBasicUser(tBasicUserModel));
      },
    );

    test(
      'should return server failure when the call to remote data  source is unsuccessfull',
      () async {
        //arrange
        when(mockRemoteDataSource.getBasicUser()).thenThrow(ServerException());
        //act
        final result = await repository.getBasicUser();
        //assert
        verify(mockRemoteDataSource.getBasicUser());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      },
    );
  });

  group('device is offline', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });
    test(
      'should return locally cached data when the cached data is present',
      () async {
        //arrange
        when(mockLocalDataSource.getBasicUser())
            .thenAnswer((_) async => tBasicUserModel);
        //act
        final result = await repository.getBasicUser();
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getBasicUser());
        expect(result, Right(tBasicUser));
      },
    );
    test(
      'should return CacheFailure when the cached data is not present',
      () async {
        //arrange
        when(mockLocalDataSource.getBasicUser()).thenThrow(CacheException());
        //act
        final result = await repository.getBasicUser();
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getBasicUser());
        expect(result, equals(Left(CacheFailure())));
      },
    );
  });
}
