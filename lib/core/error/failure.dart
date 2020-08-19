import 'package:equatable/equatable.dart';

const int SERVER_FAILURE_CODE = 100;
const int AUTH_FAILURE_CODE = 200;
const int CONNECTION_FAILURE_CODE = 300;
const int VERIFICATION_FAILURE_CODE = 400;
const int CACHE_FAILURE_CODE = 400;

abstract class Failure extends Equatable {
  Failure([List properties = const <dynamic>[]]) : super();
  int get code;
}

//General Failures
class ServerFailure extends Failure {
  int get code => SERVER_FAILURE_CODE;

  @override
  List<Object> get props => [code];
}

class ConnectionFailure extends Failure {
  int get code => CONNECTION_FAILURE_CODE;

  @override
  List<Object> get props => [code];
}

class VerificationFailure extends Failure {
  int get code => VERIFICATION_FAILURE_CODE;

  @override
  List<Object> get props => [code];
}

class AuthenticationFailure extends Failure {
  int get code => AUTH_FAILURE_CODE;

  @override
  List<Object> get props => [code];
}

class CacheFailure extends Failure {
  int get code => CACHE_FAILURE_CODE;

  @override
  List<Object> get props => [code];
}
