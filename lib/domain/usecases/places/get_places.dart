import 'package:freshOk/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/repositories/places/get_places_repository.dart';

class GetPlaces extends Usecase<List<dynamic>, NoParams> {
  final GetPlacesRepository repository;

  GetPlaces(this.repository);

  @override
  Future<Either<Failure, List<dynamic>>> call(NoParams params) async {
    return await repository.getPlaces();
  }
}
