import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/core/util/util.dart';
import 'package:freshOk/presentation/screens/cart/cart_screen_bloc/cart_screen_bloc.dart';
import 'package:freshOk/presentation/screens/cart/widgets/cart_container.dart';
import 'package:freshOk/presentation/widgets/card_shimmer.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';

class CartBillingSection extends StatelessWidget {
  const CartBillingSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartScreenBloc cartScreenBloc = context.bloc<CartScreenBloc>();
    Measure measure = MeasureImpl(context);
    return CartContainer(
      border: Border.all(
        width: 0.1,
        color: Color(0xff707070),
      ),
      boxShadow: <BoxShadow>[
        BoxShadow(
          blurRadius: 1,
          offset: Offset(0, 0),
          color: Color(0x29000000),
        )
      ],
      child: BlocBuilder<CartScreenBloc, CartScreenState>(
        builder: (context, state) {
          if (state is CartScreenLoaded) {
            final costs = Util.getMoneyValuesFromOrder(
              coupon: cartScreenBloc.selCoupon,
              deliveryCharges: state.cart.deliveryCharges,
              order: state.cart.cart,
              usedFreshOkCredit:
                  cartScreenBloc.useCredits ? cartScreenBloc.usedCredits : 0,
            );

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RegularText(
                    text: "BILL DETAILS",
                    color: AppTheme.black5,
                    fontSize: AppTheme.regularTextSize,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 5 + measure.screenHeight * 0.01),
                  CartBillingItem(
                    title: "Item Total",
                    amount: costs['itemTotal'],
                  ),
                  CartBillingItem(
                    title: "Delivery Fee",
                    amount: costs['deliveryFee'],
                  ),
                  CartBillingItem(
                    title: "Taxes and Charges",
                    amount: 0,
                  ),
                  costs['discount'] != '0'
                      ? CartBillingItem(
                          title: "DEL50",
                          amount: costs['discount'],
                          negative: true,
                        )
                      : Container(),
                  costs['freshOkCredits'] != '0'
                      ? CartBillingItem(
                          title: "freshOk Credits",
                          amount: costs['freshOkCredits'],
                          negative: true,
                        )
                      : Container(),
                  SizedBox(height: 5 + measure.screenHeight * 0.01),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 0.2,
                          color: Color(0xff707070),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5 + measure.screenHeight * 0.01),
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RegularText(
                            text: "Final Amount",
                            color: AppTheme.black2,
                            fontSize: AppTheme.regularTextSize,
                            fontWeight: FontWeight.bold,
                          ),
                          RegularText(
                            text: "${AppTheme.currencySymbol}" +
                                costs['grandTotal'],
                            color: AppTheme.black2,
                            fontSize: AppTheme.regularTextSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RegularText(
                            text: "Your Savings",
                            color: AppTheme.primaryColor,
                            fontSize: AppTheme.extraSmallTextSize,
                            fontWeight: FontWeight.w500,
                          ),
                          RegularText(
                            text:
                                "${AppTheme.currencySymbol}" + costs['savings'],
                            color: AppTheme.primaryColor,
                            fontSize: AppTheme.extraSmallTextSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return CardShimmer();
        },
      ),
    );
  }
}

class CartBillingItem extends StatelessWidget {
  final String title;
  final dynamic amount;
  final bool negative;
  const CartBillingItem({
    Key key,
    @required this.title,
    @required this.amount,
    this.negative,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RegularText(
            text: title,
            color: AppTheme.black5,
            fontSize: AppTheme.smallTextSize,
          ),
          RegularText(
            text:
                "${negative == true ? '-' : ''}${AppTheme.currencySymbol}$amount",
            color: AppTheme.black5,
            fontSize: AppTheme.smallTextSize,
          ),
        ],
      ),
    );
  }
}
