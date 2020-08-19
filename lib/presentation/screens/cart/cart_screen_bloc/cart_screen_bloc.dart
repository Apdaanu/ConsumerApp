import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freshOk/presentation/screens/cart/cart_screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../core/constants/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/util/util.dart';
import '../../../../data/models/order/local_cart_model.dart';
import '../../../../domain/entities/categories/product.dart';
import '../../../../domain/entities/order/book_slot.dart';
import '../../../../domain/entities/order/cart.dart';
import '../../../../domain/entities/order/coupon.dart';
import '../../../../domain/entities/order/local_cart.dart';
import '../../../../domain/entities/order/payment_order.dart';
import '../../../../domain/repositories/orders/payment_repository.dart';
import '../../../../domain/usecases/orders/get_cart_slots.dart';
import '../../../../domain/usecases/orders/get_coupons.dart';
import '../../../../domain/usecases/orders/place_order.dart';
import '../../../../domain/usecases/orders/set_remote_cart.dart';
import '../../../../domain/usecases/referral/get_freshOk_credits.dart';
import '../../../../domain/usecases/services/flutter_local_notif_service.dart';
import '../../../../main.dart';
import '../../../widgets/regular_text.dart';
import '../../paytm/PaymentScreen.dart';

part 'cart_screen_event.dart';
part 'cart_screen_state.dart';

class CartScreenBloc extends Bloc<CartScreenEvent, CartScreenState> {
  final SetRemoteCart setRemoteCart;
  final GetCoupons getCoupons;
  final GetCartSlots getCartSlots;
  final GetFreshOkCredits freshOkCredits;
  final PlaceOrder placeOrder;
  final FlutterLocalNotifService notifService;
  final PaymentRepository repository;
  final Razorpay razorpay;

  CartScreenBloc({
    @required this.setRemoteCart,
    @required this.getCoupons,
    @required this.getCartSlots,
    @required this.freshOkCredits,
    @required this.placeOrder,
    @required this.notifService,
    @required this.repository,
    @required this.razorpay,
  }) : super(CartScreenInitial());

  Cart cart;
  String paymentMode = 'online';
  List coupons;
  Coupon selCoupon;
  double freshOkCredit = 0;
  double usedCredits = 0;
  bool useCredits = false;
  bool showCoupons = false;
  bool showSlot = false;
  String userId;
  bool postingCart = false;
  PaymentOrder paymentOrder;
  var next;
  String userMob;

  BookSlot bookSlot;
  int selDate = 0;
  int selMonth = 0;
  int selYear = 0;
  String selSlot;
  bool navToPaytmPage = false;

  @override
  Stream<CartScreenState> mapEventToState(
    CartScreenEvent event,
  ) async* {
    if (event is CartScreenInitEvent) {
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);

      print('[sys] : posting cart');
      final failureOrCart = await setRemoteCart(
        SetRemoteCartParams(
          userId: event.userId,
          localCart: event.localCart,
        ),
      );
      yield* failureOrCart.fold(
        (failure) async* {
          print('[err] : failed to set cart : ${failure.code}');
        },
        (cart) async* {
          print('[sys] : Cart set');
          this.cart = cart;
          this.userId = event.userId;
          yield CartScreenLoaded(cart);
        },
      );
      final failureOrCoupons = await getCoupons(GetCouponsParams(event.userId));
      yield* failureOrCoupons.fold(
        (failure) async* {
          print('[err] : failed to fetch coupons : ${failure.code}');
        },
        (coupons) async* {
          yield CartScreenInitial();
          this.coupons = coupons;
          yield CartScreenLoaded(cart);
        },
      );

      final failureOrCredits = await freshOkCredits(
        GetFreshOkCreditsParams(event.userId),
      );
      yield* failureOrCredits.fold(
        (failure) async* {
          print('[err] : failed to get credits : ${failure.code}');
        },
        (credits) async* {
          if (credits > 0) {
            yield CartScreenInitial();
            this.freshOkCredit = credits;
            this.updateCartParams();
            yield CartScreenLoaded(this.cart);
          }
        },
      );

      final failureOrSlots = await getCartSlots(NoParams());
      yield* failureOrSlots.fold(
        (l) async* {
          print('[err] : failed to fetch slots');
        },
        (r) async* {
          print('[sys] : fetched slots');
          DateTime todaysDate = DateTime.now();
          yield CartScreenInitial();
          this.bookSlot = r;
          this.selSlot = r.slots[0].id;
          this.selDate = todaysDate.day + 1;
          this.selMonth = todaysDate.month;
          this.selYear = todaysDate.year;
          yield CartScreenLoaded(this.cart);
        },
      );
    }

    if (event is CartScreenIncQty) {
      if (event.product.quantity <= event.product.maxQty) {
        yield CartScreenInitial();
        double qty;
        if (event.product.quantity + event.product.unitQty <=
            event.product.maxQty) {
          qty = event.product.quantity + event.product.unitQty;
        } else {
          qty = event.product.maxQty;
        }
        this.cart.cart[this.cart.cart.indexOf(event.product)].quantity = qty;
        this.updateCartParams();

        yield CartScreenLoaded(cart);
      }
    }

    if (event is CartScreenDecQty) {
      yield CartScreenInitial();
      if (event.product.quantity - event.product.unitQty >=
          event.product.minQty) {
        this.cart.cart[this.cart.cart.indexOf(event.product)].quantity =
            event.product.quantity - event.product.unitQty;
        yield CartScreenLoaded(cart);
      } else if (event.product.quantity == event.product.minQty) {
        return;
      } else {
        this.cart.cart[this.cart.cart.indexOf(event.product)].quantity =
            event.product.minQty;
        yield CartScreenLoaded(cart);
      }
      yield CartScreenInitial();

      this.updateCartParams();
      yield CartScreenLoaded(cart);
    }

    if (event is CartScreenRemQty) {
      yield CartScreenInitial();
      this.cart.cart.remove(event.product);
      this.updateCartParams();

      yield CartScreenLoaded(cart);
    }

    if (event is CartScreenToggleCredits) {
      if (this.freshOkCredit > 0) {
        yield CartScreenInitial();
        this.useCredits = !this.useCredits;
        this.selCoupon = null;
        this.updateCartParams();
        yield CartScreenLoaded(this.cart);
      } else {
        this.showAlertDialog(
          cartScreenKey.currentContext,
          'Insifficient credits',
          'Your account has insufficient credits, refer freshOk to people to earn more credits',
        );
      }
    }

    if (event is CartScreenPaymentEvent) {
      yield CartScreenInitial();
      this.paymentMode = event.mode;
      this.updateCartParams();
      yield CartScreenLoaded(this.cart);
    }

    if (event is CartScreenToggleCoupons) {
      yield CartScreenInitial();
      this.showCoupons = !this.showCoupons;
      this.updateCartParams();

      yield CartScreenLoaded(this.cart);
    }

    if (event is CartScreenApplyCoupon) {
      if (event.coupon == null) {
        yield CartScreenInitial();
        this.selCoupon = null;
        this.updateCartParams();
        yield CartScreenLoaded(this.cart);
        return;
      }
      if (this.selCoupon != null && this.selCoupon.id == event.coupon.id) {
        yield CartScreenInitial();
        this.selCoupon = null;
        this.updateCartParams();
        yield CartScreenLoaded(this.cart);
        return;
      }
      final costs = Util.getMoneyValuesFromOrder(
        coupon: this.selCoupon,
        deliveryCharges: this.cart.deliveryCharges,
        order: this.cart.cart,
        usedFreshOkCredit: this.useCredits ? this.usedCredits : 0,
      );

      if (double.parse(costs['itemTotal']) >= event.coupon.properties.limit) {
        yield CartScreenInitial();
        this.selCoupon = event.coupon;
        this.useCredits = false;
        this.updateCartParams();
        yield CartScreenLoaded(this.cart);
      } else {
        print('[dbg] : Coupon invalid');
        showAlertDialog(
          cartScreenKey.currentContext,
          'Coupon not applicable',
          'This coupon is applicable on orders with \'Item Total\' above ' +
              AppTheme.currencySymbol +
              Util.removeDecimalZeroFormat(event.coupon.properties.limit) +
              ' only',
        );
      }
    }

    if (event is CartScreenToggleSlot) {
      yield CartScreenInitial();
      this.showSlot = !this.showSlot;
      yield CartScreenLoaded(this.cart);
    }

    if (event is CartScreenSelDate) {
      yield CartScreenInitial();
      this.selDate = event.date;
      this.selMonth = event.month;
      this.selYear = event.year;
      yield CartScreenLoaded(this.cart);
    }

    if (event is CartScreenSelSlot) {
      yield CartScreenInitial();
      this.selSlot = event.slotId;
      yield CartScreenLoaded(this.cart);
    }

    if (event is CartScreenPlaceOrderEvent) {
      if (!this.postingCart) {
        yield CartScreenInitial();
        this.postingCart = true;
        this.next = event.next;
        yield CartScreenLoaded(this.cart);

        final Map<String, dynamic> localCart = Map<String, dynamic>();
        this.cart.cart.forEach((element) {
          localCart[element.productId] = element.quantity;
        });
        print('[sys] : setting remote cart');
        final failureOrCart = await setRemoteCart(
          SetRemoteCartParams(
            userId: this.userId,
            localCart: LocalCartModel(localCart),
          ),
        );
        yield* failureOrCart.fold(
          (failure) async* {
            print('[err] : failed to set cart : ${failure.code}');
          },
          (cart) async* {
            print('[sys] : Cart set');
            this.cart = cart;
            yield CartScreenLoaded(cart);
            final costs = Util.getMoneyValuesFromOrder(
              coupon: this.selCoupon,
              deliveryCharges: this.cart.deliveryCharges,
              order: this.cart.cart,
              usedFreshOkCredit: this.useCredits ? this.usedCredits : 0,
            );
            if (costs['grandTotal'] == '0') {
              await handlePlaceOrder(null);
              yield CartScreenInitial();
              yield CartScreenLoaded(this.cart);
            } else if (this.paymentMode == 'cod') {
              await handlePlaceOrder(null);
              yield CartScreenInitial();
              yield CartScreenLoaded(this.cart);
            } else if (this.paymentMode == 'online') {
              print('[sys] : creating payment order');
              this.userMob = event.mob.toString();
              final costs = Util.getMoneyValuesFromOrder(
                coupon: this.selCoupon,
                deliveryCharges: this.cart.deliveryCharges,
                order: this.cart.cart,
                usedFreshOkCredit: this.useCredits ? this.usedCredits : 0,
              );
              final failureOrPaymentOrder = await repository.createPaymentOrder(
                amount: double.parse(costs['grandTotal']),
              );

              yield* failureOrPaymentOrder.fold(
                (failure) async* {
                  print(
                      '[err] : payment order creation failed : ${failure.code}');
                },
                (paymentOrder) async* {
                  this.paymentOrder = paymentOrder;
                  final options = {
                    "key": 'rzp_test_hlv5DMNoaah536',
                    // 'key_secret': 'xnZY0J36t6BycHVwJ94cmNDt',
                    'currency': 'INR',
                    // "key": 'rzp_live_gHESdmUT1QLKTn',
                    // "key_secret": 'feMngalGvr86qgM9Fjfl815p',
                    'amount': paymentOrder.amount,
                    'name': 'freshOk',
                    'order_id': paymentOrder.id,
                    'prefill': {
                      'contact': event.mob,
                      'email': 'yestsalvo@gmail.com'
                    },
                    'external': {
                      'wallets': ['paytm'],
                    }
                  };
                  try {
                    razorpay.open(options);
                  } catch (error) {
                    print('[err] : $error');
                  }
                },
              );
            }
          },
        );
      }
    }

    if (event is CancelledPaymentEvent) {
      yield CartScreenInitial();
      this.postingCart = false;
      yield CartScreenLoaded(this.cart);
    }
  }

  void showAlertDialog(BuildContext context, String title, String msg) {
    // set up the buttons
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: RegularText(
        text: title,
        color: AppTheme.black2,
        fontSize: AppTheme.headingTextSize,
        fontWeight: FontWeight.w700,
      ),
      content: RegularText(
        text: msg,
        color: AppTheme.black5,
        fontSize: AppTheme.regularTextSize,
        overflow: false,
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void updateCartParams() {
    final costs = Util.getMoneyValuesFromOrder(
      coupon: this.selCoupon,
      deliveryCharges: this.cart.deliveryCharges,
      order: this.cart.cart,
      usedFreshOkCredit: this.useCredits ? this.usedCredits : 0,
    );
    if (this.selCoupon != null) {
      if (double.parse(costs['itemTotal']) < this.selCoupon.properties.limit) {
        this.selCoupon = null;
        this.useCredits = true;
      }
    }

    final double itemTotal = double.parse(costs['itemTotal']);

    double credits = min(itemTotal * this.cart.creditLimit, this.freshOkCredit)
        .floor()
        .toDouble();
    if (credits < 0) {
      this.usedCredits = 0;
    } else {
      this.usedCredits = credits;
    }
    if (costs['grandTotal'] == '0') {
      this.paymentMode = 'online';
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) async {
    final failureOrSuccess = await repository.capturePayment(
      amount: this.paymentOrder.amount,
      razorpayResponse: response,
    );

    failureOrSuccess.fold(
      (failure) async {
        print('[err] : failed to capture payment : ${failure.code}');
      },
      (paymentResponse) async {
        print('[sys] : payment successfully captured');
        handlePlaceOrder(paymentResponse);
      },
    );
  }

  handlePaymentError(PaymentFailureResponse response) {
    print('[dbg] : $response');
    this.postingCart = false;
    this.add(CancelledPaymentEvent());
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    if (!navToPaytmPage) {
      this.navToPaytmPage = true;
      this.add(CancelledPaymentEvent());
      print('[dbg] : okay');
      navigatorKey.currentState.push(
        MaterialPageRoute(
          builder: (context) => PaytmPaymentScreen(
            amount: paymentOrder.amount.toString(),
            orderId: paymentOrder.id,
            email: "yestsalvo@gmail.com",
            // mob: userMob,
            mob: "7777777777",
            //To accomodate navtopaytm after payment cancel
            iniS: () {
              this.navToPaytmPage = false;
            },
            userId: this.userId,
            next: handlePlaceOrder,
          ),
        ),
      );
    }
  }

  Future<void> handlePlaceOrder(paymentResponse) async {
    print('[sys] : placing order');
    final String dateString = this.selYear.toString() +
        this.selMonth.toString().padLeft(2, '0') +
        this.selDate.toString().padLeft(2, '0');

    final String utcString = DateTime.parse(dateString).toIso8601String();
    print('[dbg] : ${this.paymentMode} ------------------------->');
    final failureOrOrder = await placeOrder(
      PlaceOrderParams(
        userId: this.userId,
        couponId: this.selCoupon != null ? this.selCoupon.id : null,
        usedFreshOkCredit: this.useCredits ? this.usedCredits : 0,
        paymentResponse: paymentResponse,
        paymentType: this.paymentMode,
        slotId: this.selSlot,
        date: utcString,
      ),
    );
    failureOrOrder.fold(
      (failure) {
        print('[err] : failed to place order : ${failure.code}');
        this.postingCart = false;
      },
      (order) {
        print('[sys] : order successfully placed : ${order.orderId}');
        notifService.sendNotif(
          title: 'Order Placed',
          body: 'OrderId : ${order.orderId}',
          payload: {
            "route": orderDetailsRoute,
            "orderId": order.id,
          },
        );
        navigatorKey.currentState.pushNamed(
          orderPlacedRoute,
          arguments: order.id,
        );
        this.next();
      },
    );
  }
}
