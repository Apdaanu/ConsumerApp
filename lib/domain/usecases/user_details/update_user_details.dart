import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:freshOk/core/error/failure.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/entities/user_details.dart';
import 'package:freshOk/domain/repositories/user_details/user_details_repository.dart';

class UpdateUserDetails implements Usecase<UserDetails, UpdateDetailaParams> {
  final UserDetailsRepository repository;

  UpdateUserDetails(this.repository);

  @override
  Future<Either<Failure, UserDetails>> call(UpdateDetailaParams params) async {
    return await repository.updateUserDetails(
      name: params.name,
      address: params.address,
      cityId: params.cityId,
      areaId: params.areaId,
      landmark: params.landmark,
      pin: params.pin,
      imageUrl: params.imageUrl,
    );
  }
}

class UpdateDetailaParams extends Equatable {
  final String name;
  final String address;
  final String cityId;
  final String areaId;
  final String landmark;
  final String pin;
  final String imageUrl;

  UpdateDetailaParams({
    @required this.name,
    @required this.address,
    @required this.cityId,
    @required this.areaId,
    @required this.landmark,
    @required this.pin,
    @required this.imageUrl,
  });

  @override
  List<Object> get props => [
        name,
        address,
        cityId,
        areaId,
        landmark,
        pin,
        imageUrl,
      ];
}
