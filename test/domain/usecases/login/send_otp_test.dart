import 'package:dartz/dartz.dart';
import 'package:freshOk/domain/repositories/login/otp_handler_repository.dart';
import 'package:freshOk/domain/usecases/login/send_otp.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockOtpHandlerRepository extends Mock implements OtpHandlerRepository {}

void main() {
  SendOtp usecase;
  MockOtpHandlerRepository mockOtpHandlerRepository;

  setUp(() {
    mockOtpHandlerRepository = MockOtpHandlerRepository();
    usecase = SendOtp(mockOtpHandlerRepository);
  });

  test(
    'should get boolean response from the repository',
    () async {
      //arrange
      when(mockOtpHandlerRepository.sendOtp(any))
          .thenAnswer((_) async => Right(true));
      //act
      final result = await usecase(Params(mob: 9560529649));
      //assert
      expect(result, equals(Right(true)));
    },
  );
}
