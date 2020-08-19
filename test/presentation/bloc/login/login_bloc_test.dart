import 'package:dartz/dartz.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/entities/basic_user.dart';
import 'package:freshOk/domain/usecases/login/get_basic_user.dart';
import 'package:freshOk/domain/usecases/login/send_otp.dart';
import 'package:freshOk/domain/usecases/login/verify_otp.dart';
import 'package:freshOk/presentation/bloc/login/login_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetBasicUser extends Mock implements GetBasicUser {}

class MockSendOtp extends Mock implements SendOtp {}

class MockVerifyOtp extends Mock implements VerifyOtp {}

void main() {
  LoginBloc bloc;
  MockGetBasicUser mockGetBasicUser;
  MockSendOtp mockSendOtp;
  MockVerifyOtp mockVerifyOtp;

  setUp(() {
    mockGetBasicUser = MockGetBasicUser();
    mockSendOtp = MockSendOtp();
    mockVerifyOtp = MockVerifyOtp();

    bloc = LoginBloc(
      getBasicUser: mockGetBasicUser,
      sendOtp: mockSendOtp,
      verifyOtp: mockVerifyOtp,
    );
  });

  test('initial state should be empty', () {
    //assert
    expect(bloc.initialState, equals(LoginInitial()));
  });

  group('boot', () {
    final tBasicUser = BasicUser(mob: 123, newUser: false);
    test(
      'should call GetUser usecase',
      () async {
        //arrange
        when(mockGetBasicUser(NoParams()))
            .thenAnswer((_) async => Right(tBasicUser));
        //act
        bloc.add(BootEvent());
        await untilCalled(mockGetBasicUser(NoParams()));
        //assert
        verify(mockGetBasicUser(NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data gotten successfully',
      () async {
        //arrange
        when(mockGetBasicUser(NoParams()))
            .thenAnswer((_) async => Right(tBasicUser));
        //assert later
        final expected = [
          LoginInitial(),
          Loading(),
          Loaded(basicUser: tBasicUser)
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        //act
        bloc.add(BootEvent());
      },
    );
  });
}
