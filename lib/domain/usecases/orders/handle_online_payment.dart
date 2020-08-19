// import 'package:dartz/dartz.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/foundation.dart';
// import 'package:freshOk/core/error/failure.dart';
// import 'package:freshOk/core/usecases/usecase.dart';
// import 'package:freshOk/domain/entities/order/payment_order.dart';
// import 'package:freshOk/domain/repositories/orders/payment_repository.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

// class HandleOnlinePayment implements Usecase<void, OnlinePaymentParams> {
//   final PaymentRepository repository;
//   final Razorpay razorpay;

//   HandleOnlinePayment({
//     @required this.repository,
//     @required this.razorpay,
//   });

//   PaymentOrder paymentOrder;

//   @override
//   Future<Either<Failure, void>> call(OnlinePaymentParams params) async {
//     razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
//     razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
//     razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);

//     final failureOrPaymentOrder = await repository.createPaymentOrder(
//       amount: params.amount,
//     );

//     return failureOrPaymentOrder.fold(
//       (failure) async {
//         print('[err] : payment order creation failed : ${failure.code}');
//         return Left(failure);
//       },
//       (paymentOrder) async {
//         this.paymentOrder = paymentOrder;
//         final options = {
//           "key": 'rzp_test_hlv5DMNoaah536',
//           // 'key_secret': 'xnZY0J36t6BycHVwJ94cmNDt',
//           'currency': 'INR',
//           // "key": 'rzp_live_gHESdmUT1QLKTn',
//           // "key_secret": 'feMngalGvr86qgM9Fjfl815p',
//           'amount': paymentOrder.amount,
//           'name': 'freshOk',
//           'order_id': paymentOrder.id,
//           'prefill': {'contact': params.mob, 'email': 'yestsalvo@gmail.com'},
//           'external': {
//             'wallets': ['paytm'],
//           }
//         };
//         try {
//           return Right(razorpay.open(options));
//         } catch (error) {
//           return Left(ServerFailure());
//         }
//       },
//     );
//   }

//   void handlePaymentSuccess(PaymentSuccessResponse response) async {
//     final failureOrSuccess = await repository.capturePayment(
//       amount: paymentOrder.amount,
//       razorpayResponse: response,
//     );

//     failureOrSuccess.fold(
//       (failure) async {
//         print('[err] : failed to capture payment : ${failure.code}');
//       },
//       (success) async {
//         print('[sys] : payment successfully captured');
//       },
//     );
//   }

//   void handlePaymentError() {}

//   void handleExternalWallet() {}
// }

// class OnlinePaymentParams extends Equatable {
//   final double amount;
//   final String mob;
//   final handleSuccess;
//   final String userId;
//   final String couponId;
//   final

//   OnlinePaymentParams({
//     @required this.amount,
//     @required this.mob,
//     @required this.handleSuccess,
//     @required this.params,
//   });

//   @override
//   List<Object> get props => [amount, mob];
// }
