import 'package:dartz/dartz.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:freshOk/data/datasources/logout/logout_local_datasource.dart';
import 'package:freshOk/domain/repositories/logout/logout_repository.dart';

class LogoutRepositoryImpl implements LogoutRepository {
  final LogoutLocalDatasource localDatasource;

  LogoutRepositoryImpl(this.localDatasource);

  @override
  Future<Either<Failure, void>> logout() async {
    localDatasource.logout();
    return Right(null);
  }
}
