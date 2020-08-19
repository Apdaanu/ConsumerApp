part of 'order_details_bloc.dart';

abstract class OrderDetailsState extends Equatable {
  const OrderDetailsState();
}

class OrderDetailsInitial extends OrderDetailsState {
  @override
  List<Object> get props => [];
}

class OrderDetailsLoading extends OrderDetailsState {
  @override
  List<Object> get props => [];
}

class OrderDetailsLoaded extends OrderDetailsState {
  final Order order;

  OrderDetailsLoaded(this.order);

  @override
  List<Object> get props => [order];
}
