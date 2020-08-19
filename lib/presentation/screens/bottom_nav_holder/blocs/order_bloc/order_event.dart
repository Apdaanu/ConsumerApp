part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
}

class OrderInitEvent extends OrderEvent {
  final String userId;

  OrderInitEvent(this.userId);

  @override
  List<Object> get props => [userId];
}
