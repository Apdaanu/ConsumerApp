part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();
}

class OrderInitial extends OrderState {
  @override
  List<Object> get props => [];
}

class OrderLoading extends OrderState {
  @override
  List<Object> get props => [];
}

class OrderLoaded extends OrderState {
  final List orders;

  OrderLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}
