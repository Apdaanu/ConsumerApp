part of 'order_details_bloc.dart';

abstract class OrderDetailsEvent extends Equatable {
  const OrderDetailsEvent();
}

class OrderDetailsInitEvent extends OrderDetailsEvent {
  final String orderId;
  final String userId;

  OrderDetailsInitEvent({
    @required this.orderId,
    @required this.userId,
  });

  @override
  List<Object> get props => [orderId, userId];
}

class CancelOrderEvent extends OrderDetailsEvent {
  @override
  List<Object> get props => [];
}
