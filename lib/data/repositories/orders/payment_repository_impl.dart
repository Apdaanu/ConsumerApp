import 'package:flutter/foundation.dart';
import 'package:freshOk/core/error/exceptions.dart';
import 'package:freshOk/core/netowrk/network_info.dart';
import 'package:freshOk/data/datasources/orders/payment_remote_datasource.dart';
import 'package:freshOk/data/models/order/payment_order_model.dart';
import 'package:freshOk/domain/entities/order/payment_order.dart';

import 'package:freshOk/core/error/failure.dart';

import 'package:dartz/dartz.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../domain/repositories/orders/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  PaymentRepositoryImpl({
    @required this.remoteDatasource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, PaymentOrder>> createPaymentOrder({
    double amount,
    String currency = 'INR',
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final PaymentOrderModel paymentOrderModel =
            await remoteDatasource.createPaymentOrder(
          amount: amount,
          currency: currency,
        );
        return Right(paymentOrderModel);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Map>> capturePayment({
    @required double amount,
    String currency = 'INR',
    @required PaymentSuccessResponse razorpayResponse,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final paymentRes = await remoteDatasource.capturePayment(
          amount: amount,
          razorpayResponse: razorpayResponse,
        );
        return Right(paymentRes);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
