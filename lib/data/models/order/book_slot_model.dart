import 'package:flutter/foundation.dart';
import 'package:freshOk/domain/entities/order/book_slot.dart';

class BookSlotModel extends BookSlot {
  BookSlotModel({
    @required int dateOffset,
    @required List slots,
  }) : super(
          dateOffset: dateOffset,
          slots: slots,
        );

  factory BookSlotModel.fromJson(Map<String, dynamic> json) {
    return BookSlotModel(
      dateOffset: json['dateOffset'],
      slots: json['slots'].map((slot) => SlotsModel.fromJson(slot)).toList(),
    );
  }
}

class SlotsModel extends Slots {
  SlotsModel({
    @required int number,
    @required String startTime,
    @required String endTime,
    @required String id,
  }) : super(
          number: number,
          startTime: startTime,
          endTime: endTime,
          id: id,
        );

  factory SlotsModel.fromJson(Map<String, dynamic> json) {
    return SlotsModel(
      number: json['number'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      id: json['_id'],
    );
  }
}
