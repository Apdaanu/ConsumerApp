import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '../../../core/error/failure.dart';

abstract class ImageRepository {
  Future<Either<Failure, String>> uploadImage({
    @required String filename,
    @required File file,
  });
}
