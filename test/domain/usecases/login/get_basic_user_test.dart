import 'package:dartz/dartz.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/entities/basic_user.dart';
import 'package:freshOk/domain/repositories/login/basic_user_repository.dart';
import 'package:freshOk/domain/usecases/login/get_basic_user.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetBasicUserRepository extends Mock implements BasicUserRepository {}

void main() {
  GetBasicUser usecase;
  MockGetBasicUserRepository mockGetBasicUserRepository;

  setUp(() {
    mockGetBasicUserRepository = MockGetBasicUserRepository();
    usecase = GetBasicUser(mockGetBasicUserRepository);
  });

  final tBasicUser = BasicUser(mob: 9560529649, newUser: true);

  test(
    'should get basic user from the repository',
    () async {
      //arrange
      when(mockGetBasicUserRepository.getBasicUser())
          .thenAnswer((_) async => Right(tBasicUser));

      //act
      final result = await usecase(NoParams());

      //assert
      expect(result, Right(tBasicUser));
      verify(mockGetBasicUserRepository.getBasicUser());
      verifyNoMoreInteractions(mockGetBasicUserRepository);
    },
  );
}
