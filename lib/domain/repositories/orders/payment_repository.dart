import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../core/error/failure.dart';
import '../../entities/order/payment_order.dart';

abstract class PaymentRepository {
  Future<Either<Failure, PaymentOrder>> createPaymentOrder({
    @required double amount,
    String currency = 'INR',
  });

  Future<Either<Failure, Map>> capturePayment({
    @required double amount,
    String currency = 'INR',
    @required PaymentSuccessResponse razorpayResponse,
  });
}
