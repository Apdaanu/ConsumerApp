import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/pop_lock_bloc/pop_lock_bloc.dart';

import '../../../core/constants/measure.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../domain/entities/order/coupon.dart';
import '../../../injection_container.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/no_items_widget.dart';
import '../../widgets/regular_text.dart';
import '../../widgets/top_bar.dart';
import '../bottom_nav_holder/blocs/bottom_nav/bottom_nav_bloc.dart';
import '../bottom_nav_holder/blocs/cart_bloc/cart_bloc.dart';
import '../bottom_nav_holder/blocs/mitra_bloc/mitra_bloc.dart';
import '../bottom_nav_holder/blocs/pop_address_bloc/pop_address_bloc.dart';
import '../bottom_nav_holder/blocs/user_details_bloc/user_details_bloc.dart';
import 'cart_screen_bloc/cart_screen_bloc.dart';
import 'widgets/cart_address_display_section.dart';
import 'widgets/cart_billing_section.dart';
import 'widgets/cart_book_slot.dart';
import 'widgets/cart_coupon_section.dart';
import 'widgets/cart_credit_section.dart';
import 'widgets/cart_delivery_partner_section.dart';
import 'widgets/cart_item_summary_secion.dart';
import 'widgets/cart_payment_section.dart';

GlobalKey cartScreenKey = new GlobalKey();

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc _cartBloc;
  BottomNavBloc _bottomNavBloc;
  CartScreenBloc _cartScreenBloc;
  UserDetailsBloc _userDetailsBloc;
  PopAddressBloc _popAddressBloc;
  MitraBloc _mitraBloc;
  PopLockBloc _popLockBloc;

  @override
  void initState() {
    super.initState();
    _cartBloc = context.bloc<CartBloc>();
    _bottomNavBloc = context.bloc<BottomNavBloc>();
    _userDetailsBloc = context.bloc<UserDetailsBloc>();
    _cartScreenBloc = sl<CartScreenBloc>();
    _popAddressBloc = context.bloc<PopAddressBloc>();
    _mitraBloc = context.bloc<MitraBloc>();
    _popLockBloc = context.bloc();

    _cartScreenBloc.add(
      CartScreenInitEvent(
        userId: _userDetailsBloc.userDetails.userId,
        localCart: _cartBloc.cart,
      ),
    );
  }

  @override
  void dispose() {
    _cartScreenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Stack(
      key: cartScreenKey,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3 + measure.width * 0.02),
          color: AppTheme.greyFB,
          child: BlocBuilder(
            cubit: _cartBloc,
            builder: (context, state) {
              if (state is CartLoaded) {
                if (state.cart.cart.length > 0) {
                  return SingleChildScrollView(
                    child: BlocProvider.value(
                      value: _cartScreenBloc,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 15 + measure.screenHeight * 0.01),
                          SizedBox(height: 15 + measure.screenHeight * 0.01),
                          CartAddressDisplaySection(),
                          SizedBox(height: 15 + measure.screenHeight * 0.01),
                          CartDeliveryPartnerSection(),
                          SizedBox(height: 15 + measure.screenHeight * 0.01),
                          CartItemSummarySection(),
                          SizedBox(height: 15 + measure.screenHeight * 0.01),
                          CartCouponSection(),
                          SizedBox(height: 15 + measure.screenHeight * 0.01),
                          CartCreditsSection(),
                          SizedBox(height: 15 + measure.screenHeight * 0.01),
                          CartPaymentSection(),
                          SizedBox(height: 15 + measure.screenHeight * 0.01),
                          CartBillingSection(),
                          SizedBox(height: 15 + measure.screenHeight * 0.01),
                          SizedBox(height: 45 + measure.screenHeight * 0.03),
                        ],
                      ),
                    ),
                  );
                } else {
                  return NoItemsWidget(
                    title: 'EMPTY CART',
                    image: 'assets/images/cart_empty.png',
                    description: 'Looks like you haven\'t made your choice yet',
                    buttonText: 'Browse Products',
                    btnFxn: () {
                      _bottomNavBloc.add(0);
                    },
                    btnColor: Color(0xffe07156),
                  );
                }
              }
              return Container();
            },
          ),
        ),
        BlocBuilder(
          cubit: _cartScreenBloc,
          builder: (context, state) {
            if (_cartBloc.cart.cart.length > 0) {
              return Positioned(
                bottom: 0,
                child: Container(
                  width: measure.width,
                  padding: EdgeInsets.symmetric(
                      vertical: 10 + measure.screenHeight * 0.01),
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: CustomButton(
                    height: 25 + measure.screenHeight * 0.02,
                    width: measure.width * 0.96 - 8,
                    onTap: () {
                      if (state is CartScreenLoaded) {
                        if (_userDetailsBloc.userDetails.address == null ||
                            _userDetailsBloc.userDetails.address == '') {
                          _popAddressBloc.add(PopAddressEvent.show);
                          return;
                        }
                        if (_mitraBloc.selMitra == null) {
                          Navigator.pushNamed(context, selectMitraRoute);
                          return;
                        }
                        if (!_cartScreenBloc.postingCart) {
                          _popLockBloc.add(
                            PopLockAcquire(
                              () {
                                _cartScreenBloc.add(CartScreenToggleSlot());
                              },
                            ),
                          );
                          _cartScreenBloc.add(CartScreenToggleSlot());
                        }
                        // _cartScreenBloc.add(
                        // CartScreenPlaceOrderEvent(
                        //   next: () {
                        //     _cartBloc.add(CartClearEvent());
                        //   },
                        //   mob: _userDetailsBloc.basicUser.mob.toString(),
                        // ),
                        // );
                      }
                    },
                    color: _cartScreenBloc.postingCart
                        ? Colors.grey[300]
                        : AppTheme.primaryColor,
                    child: Center(
                      child: _cartScreenBloc.postingCart
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    AppTheme.primaryColor),
                                strokeWidth: 2,
                              ),
                            )
                          // JumpingDotsProgressIndicator(
                          //     numberOfDots: 3,
                          //     fontSize: 30.0,
                          //     color: Colors.white,
                          //     milliseconds: 100,
                          //   )
                          : RegularText(
                              text: "Place Order",
                              color: Colors.white,
                              fontSize: AppTheme.headingTextSize,
                            ),
                    ),
                  ),
                ),
              );
            } else
              return Container();
          },
        ),
        BlocBuilder(
          cubit: _cartScreenBloc,
          builder: (context, state) => Positioned(
            bottom: 0,
            child: AnimatedOpacity(
              opacity: _cartScreenBloc.showCoupons ? 1 : 0,
              duration: Duration(milliseconds: 150),
              child: Container(
                height:
                    _cartScreenBloc.showCoupons ? measure.screenHeight - 50 : 0,
                width: measure.width,
                color: Color(0x30000000),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _cartScreenBloc.add(CartScreenToggleCoupons());
                      },
                      child: Container(
                        height: (measure.screenHeight - 50) * 0.25,
                        color: Colors.transparent,
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 150),
                      height: _cartScreenBloc.showCoupons
                          ? (measure.screenHeight - 50) * 0.75
                          : 0,
                      width: measure.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            blurRadius: 1,
                            offset: Offset(0, -1),
                            color: Color(0x29000000),
                          )
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          // CustomTopBar(
                          //   title: 'Select Coupon',
                          //   altBackFxn: () {
                          //     _cartScreenBloc.add(CartScreenToggleCoupons());
                          //   },
                          //   action: GestureDetector(
                          //     onTap: () {
                          //       _cartScreenBloc.add(
                          //         CartScreenApplyCoupon(null),
                          //       );
                          //       _cartScreenBloc.add(CartScreenToggleCoupons());
                          //     },
                          //     child: RegularText(
                          //       text: 'Remove',
                          //       color: Colors.white,
                          //       fontSize: AppTheme.smallTextSize,
                          //     ),
                          //   ),
                          // ),
                          GestureDetector(
                            onTap: () {
                              _cartScreenBloc.add(CartScreenToggleCoupons());
                            },
                            child: Container(
                              color: Colors.transparent,
                              width: measure.width,
                              height: measure.topBarHeight,
                              child: Center(
                                child: RegularText(
                                  text: 'Available Coupons',
                                  color: AppTheme.black3,
                                  fontSize: AppTheme.regularTextSize,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: measure.width,
                            height: (measure.screenHeight - 50) * 0.75 -
                                measure.topBarHeight,
                            color: Colors.white,
                            child: SingleChildScrollView(
                              child: BlocProvider.value(
                                value: _cartScreenBloc,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _cartScreenBloc.showCoupons
                                      ? _renderCoupons(_cartScreenBloc.coupons)
                                      : [],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        BlocBuilder(
          cubit: _cartScreenBloc,
          builder: (context, state) => Positioned(
            bottom: 0,
            child: AnimatedContainer(
              width: measure.width,
              height: _cartScreenBloc.showSlot ? measure.screenHeight - 55 : 0,
              duration: Duration(milliseconds: 150),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  CustomTopBar(
                    title: 'Book Slot',
                    altBackFxn: () {
                      _cartScreenBloc.add(CartScreenToggleSlot());
                    },
                  ),
                  BlocProvider.value(
                    value: _cartScreenBloc,
                    child: CartBookSlot(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _renderCoupons(List coupons) {
    List<Widget> list = List<Widget>();

    if (coupons != null) {
      coupons.forEach((element) {
        list.add(CouponCard(coupon: element));
      });
    } else {}

    return list;
  }
}

class CouponCard extends StatelessWidget {
  final Coupon coupon;

  const CouponCard({Key key, this.coupon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartScreenBloc cartScreenBloc = context.bloc<CartScreenBloc>();
    Measure measure = MeasureImpl(context);

    bool isSelected = cartScreenBloc.selCoupon != null
        ? cartScreenBloc.selCoupon.id == coupon.id
        : false;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 5 + measure.width * 0.01,
        vertical: 5 + measure.screenHeight * 0.01,
      ),
      margin: EdgeInsets.only(
        left: 5 + measure.width * 0.01,
        right: 5 + measure.width * 0.01,
        bottom: 10 + measure.screenHeight * 0.02,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 0.1, color: Color(0xff000000)),
          borderRadius: BorderRadius.circular(4),
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 1,
              offset: Offset(0, 0),
              color: Color(0x29000000),
            )
          ]),
      child: Row(
        children: <Widget>[
          Container(
            height: 40 + measure.screenHeight * 0.01,
            width: 40 + measure.screenHeight * 0.01,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RegularText(
                text: coupon.code,
                color: AppTheme.black5,
                fontSize: AppTheme.regularTextSize,
                fontWeight: FontWeight.bold,
              ),
              RegularText(
                text: coupon.desc,
                color: AppTheme.black7,
                fontSize: AppTheme.smallTextSize,
              )
            ],
          ),
          Expanded(child: Container()),
          Material(
            color: isSelected ? Colors.grey[400] : AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: () {
                cartScreenBloc.add(CartScreenApplyCoupon(coupon));
                cartScreenBloc.add(CartScreenToggleCoupons());
              },
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: 100,
                height: 30,
                child: Center(
                  child: RegularText(
                    text: isSelected ? 'Applied' : 'Apply',
                    color: Colors.white,
                    fontSize: AppTheme.smallTextSize,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
