import 'package:dartz/dartz.dart';
import 'package:freshOk/core/error/failure.dart';

abstract class GetPlacesRepository {
  Future<Either<Failure, List<dynamic>>> getPlaces();
}
