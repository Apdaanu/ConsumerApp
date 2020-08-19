import 'package:dartz/dartz.dart';
import 'package:freshOk/domain/entities/basic_user.dart';
import 'package:freshOk/domain/repositories/login/otp_handler_repository.dart';
import 'package:freshOk/domain/usecases/login/verify_otp.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockOtpHandlerRepository extends Mock implements OtpHandlerRepository {}

void main() {
  MockOtpHandlerRepository mockOtpHandlerRepository;
  VerifyOtp usecase;

  setUp(() {
    mockOtpHandlerRepository = MockOtpHandlerRepository();
    usecase = VerifyOtp(mockOtpHandlerRepository);
  });

  final tBasicUser = BasicUser(mob: 123, newUser: true);

  test(
    'should return BasicUser from the repository',
    () async {
      //arrange
      when(mockOtpHandlerRepository.verifyOtp(
        mob: anyNamed('mob'),
        otp: anyNamed('otp'),
        status: anyNamed('status'),
      )).thenAnswer((_) async => Right(tBasicUser));
      //act
      final result = await usecase(Params(
        mob: 123,
        otp: 1234,
        status: 'customer',
      ));
      //assert
      verify(mockOtpHandlerRepository.verifyOtp(
        mob: 123,
        otp: 1234,
        status: 'customer',
      ));
      expect(result, equals(Right(tBasicUser)));
    },
  );
}
