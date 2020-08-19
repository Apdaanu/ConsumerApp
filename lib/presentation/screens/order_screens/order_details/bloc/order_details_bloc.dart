import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/domain/entities/order/order.dart';
import 'package:freshOk/domain/usecases/orders/cancel_order.dart';
import 'package:freshOk/domain/usecases/orders/get_order_details.dart';

part 'order_details_event.dart';
part 'order_details_state.dart';

class OrderDetailsBloc extends Bloc<OrderDetailsEvent, OrderDetailsState> {
  final GetOrderDetails getOrderDetails;
  final CancelOrder cancelOrder;

  OrderDetailsBloc({
    @required this.getOrderDetails,
    @required this.cancelOrder,
  }) : super(OrderDetailsInitial());

  String userId;
  Order order;
  bool cancelling = false;

  @override
  Stream<OrderDetailsState> mapEventToState(
    OrderDetailsEvent event,
  ) async* {
    if (event is OrderDetailsInitEvent) {
      this.userId = event.userId;
      print('[sys] : fetching order details');
      yield OrderDetailsLoading();
      final failureOrOrder = await getOrderDetails(
        GetOrderDetailsParams(
          userId: event.userId,
          orderId: event.orderId,
        ),
      );
      yield* failureOrOrder.fold(
        (failure) async* {
          print('[sys] : fetching order details failed : ${failure.code}');
        },
        (order) async* {
          print('[sys] : order details fetched');
          this.order = order;
          yield OrderDetailsLoaded(order);
        },
      );
    }

    if (event is CancelOrderEvent) {
      if (!this.cancelling) {
        yield OrderDetailsInitial();
        this.cancelling = true;
        yield OrderDetailsLoaded(this.order);
        print('[sys] : Cancelling order');
        final failureOrSuccess = await cancelOrder(
          CancelOrderParams(
            orderId: this.order.id,
            userId: this.userId,
          ),
        );
        yield* failureOrSuccess.fold(
          (failure) async* {
            print('[err] : failed to cancel order');
            yield OrderDetailsInitial();
            this.cancelling = false;
            yield OrderDetailsLoaded(this.order);
          },
          (success) async* {
            print('[sys] : canceled order');
            yield OrderDetailsInitial();
            this.order.orderStatus.add('Cancelled by user');
            this.cancelling = false;
            yield OrderDetailsLoaded(this.order);
          },
        );
      }
    }
  }
}
