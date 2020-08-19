import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:freshOk/domain/entities/categories/recepie.dart';

abstract class RecepieRepository {
  Future<Either<Failure, List>> getRecepieSections(String userId);

  Future<Either<Failure, List>> getRecepies({
    @required String userId,
    @required String sectionId,
    @required String categoryId,
    @required String type,
  });

  Future<Either<Failure, List>> getAllRecepies();

  Future<Either<Failure, Recepie>> getRecepieDetails(String recepieId);

  Future<Either<Failure, List>> getMyRecepies(String userId);

  Future<Either<Failure, List>> getLikedRecepies(String userId);

  Future<Either<Failure, void>> likeRecepie({
    @required String recepieId,
    @required String userId,
  });

  Future<Either<Failure, List>> getDishTypes();

  Future<Either<Failure, List>> getCuisinesTypes();

  Future<Either<Failure, List>> searchRecepies(String search);
}
