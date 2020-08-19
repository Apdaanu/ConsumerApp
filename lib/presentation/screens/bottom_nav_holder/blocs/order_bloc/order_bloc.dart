import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../domain/usecases/orders/get_orders.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final GetOrders getOrders;

  OrderBloc(this.getOrders) : super(OrderInitial());

  List orders = List();

  @override
  Stream<OrderState> mapEventToState(
    OrderEvent event,
  ) async* {
    if (event is OrderInitEvent) {
      yield OrderLoading();
      print('[sys] : fetching all orders');
      final failureOrOrders = await getOrders(GetOrdersParams(event.userId));
      yield* failureOrOrders.fold(
        (failure) async* {
          print('[sys] : failed to fetch orders : ${failure.code}');
        },
        (orders) async* {
          print('[sys] : orders fetched successfully');
          yield OrderLoaded(orders);
          this.orders = orders;
        },
      );
    }
  }
}
