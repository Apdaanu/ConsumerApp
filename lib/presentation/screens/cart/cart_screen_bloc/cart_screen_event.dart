part of 'cart_screen_bloc.dart';

abstract class CartScreenEvent extends Equatable {
  const CartScreenEvent();
}

class CartScreenInitEvent extends CartScreenEvent {
  final String userId;
  final LocalCart localCart;

  CartScreenInitEvent({
    @required this.userId,
    @required this.localCart,
  });

  @override
  List<Object> get props => [
        userId,
        localCart,
      ];
}

class CartScreenIncQty extends CartScreenEvent {
  final Product product;

  CartScreenIncQty(
    this.product,
  );

  @override
  List<Object> get props => [
        product,
      ];
}

class CartScreenDecQty extends CartScreenEvent {
  final Product product;

  CartScreenDecQty(
    this.product,
  );

  @override
  List<Object> get props => [
        product,
      ];
}

class CartScreenRemQty extends CartScreenEvent {
  final Product product;

  CartScreenRemQty(
    this.product,
  );

  @override
  List<Object> get props => [
        product,
      ];
}

class CartScreenToggleCredits extends CartScreenEvent {
  @override
  List<Object> get props => [];
}

class CartScreenPaymentEvent extends CartScreenEvent {
  final String mode;

  CartScreenPaymentEvent(this.mode);

  @override
  List<Object> get props => [mode];
}

class CartScreenToggleCoupons extends CartScreenEvent {
  @override
  List<Object> get props => [];
}

class CartScreenApplyCoupon extends CartScreenEvent {
  final Coupon coupon;

  CartScreenApplyCoupon(this.coupon);

  @override
  List<Object> get props => [coupon];
}

class CartScreenPlaceOrderEvent extends CartScreenEvent {
  final next;
  final String mob;

  CartScreenPlaceOrderEvent({@required this.next, @required this.mob});

  @override
  List<Object> get props => [next, mob];
}

class CancelledPaymentEvent extends CartScreenEvent {
  @override
  List<Object> get props => [];
}

class CartScreenSelDate extends CartScreenEvent {
  final int date;
  final int month;
  final int year;

  CartScreenSelDate({
    @required this.date,
    @required this.month,
    @required this.year,
  });

  @override
  List<Object> get props => [date, month, year];
}

class CartScreenSelSlot extends CartScreenEvent {
  final String slotId;

  CartScreenSelSlot(this.slotId);

  @override
  List<Object> get props => [slotId];
}

class CartScreenToggleSlot extends CartScreenEvent {
  @override
  List<Object> get props => [];
}
