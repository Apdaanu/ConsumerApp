import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:freshOk/domain/repositories/misc/image_repository.dart';

import '../../../core/error/failure.dart';

class ImageService {
  final ImageRepository repository;

  ImageService(this.repository);

  Future<Either<Failure, String>> uploadImage({
    @required String fileName,
    @required File file,
  }) async {
    return await repository.uploadImage(
      filename: fileName,
      file: file,
    );
  }
}
