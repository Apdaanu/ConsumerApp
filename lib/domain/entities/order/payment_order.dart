import 'package:flutter/foundation.dart';
import 'package:freshOk/domain/entities/base_model.dart';

class PaymentOrder extends BaseModel {
  final String id;
  final double amount;

  PaymentOrder({
    @required this.id,
    @required this.amount,
  });

  @override
  List<Object> get props => [
        id,
        amount,
      ];
}
