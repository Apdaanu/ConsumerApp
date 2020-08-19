import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/error/exceptions.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:freshOk/core/netowrk/network_info.dart';
import 'package:freshOk/data/datasources/places/get_places_datasource.dart';
import 'package:freshOk/data/models/places/city_model.dart';
import 'package:freshOk/domain/entities/place/city.dart';
import 'package:freshOk/domain/repositories/places/get_places_repository.dart';

class GetPlacesRepositoryImpl implements GetPlacesRepository {
  final NetworkInfo networkInfo;
  final GetPlacesDatasource datasource;

  GetPlacesRepositoryImpl({
    @required this.networkInfo,
    @required this.datasource,
  });

  @override
  Future<Either<Failure, List<dynamic>>> getPlaces() async {
    if (await networkInfo.isConnected) {
      try {
        List<dynamic> places = await datasource.getPlaces();
        return Right(places);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
