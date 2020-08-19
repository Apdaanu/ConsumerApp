import 'package:flutter/foundation.dart';
import 'package:freshOk/domain/entities/base_model.dart';

class BookSlot extends BaseModel {
  final int dateOffset;
  final List slots;

  BookSlot({
    @required this.dateOffset,
    @required this.slots,
  });

  @override
  List<Object> get props => [dateOffset, slots];
}

class Slots extends BaseModel {
  final int number;
  final String startTime;
  final String endTime;
  final String id;

  Slots({
    @required this.number,
    @required this.startTime,
    @required this.endTime,
    @required this.id,
  });

  @override
  List<Object> get props => [
        number,
        startTime,
        endTime,
        id,
      ];
}
