import 'package:flutter/foundation.dart';
import 'package:freshOk/domain/entities/base_model.dart';

class Chat extends BaseModel {
  final String status;
  final String message;

  Chat({
    @required this.status,
    @required this.message,
  });

  @override
  List<Object> get props => [
        status,
        message,
      ];
}
