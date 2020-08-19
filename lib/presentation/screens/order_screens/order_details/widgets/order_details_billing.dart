import 'package:flutter/material.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/core/util/util.dart';
import 'package:freshOk/domain/entities/order/order.dart';
import 'package:freshOk/presentation/screens/order_screens/order_details/widgets/order_details_section_container.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';

class OrderDetailsBilling extends StatelessWidget {
  final Order order;

  const OrderDetailsBilling({
    Key key,
    @required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    final orderCosts = Util.getMoneyValuesFromOrder(
      coupon: order.discount,
      deliveryCharges: order.deliveryCharges,
      order: order.order,
      usedFreshOkCredit: order.usedFreshOkCredit,
    );

    return OrderDetailsSectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 5 + measure.screenHeight * 0.01),
          RegularText(
            text: "BILL DETAILS",
            color: AppTheme.black5,
            fontSize: AppTheme.regularTextSize,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 5 + measure.screenHeight * 0.01),
          OrderDetailsBillingItem(
            title: "Item Total",
            amount: orderCosts['itemTotal'],
          ),
          OrderDetailsBillingItem(
            title: "Delivery Fee",
            amount: orderCosts['deliveryFee'],
          ),
          OrderDetailsBillingItem(
            title: "Taxes and Charges",
            amount: orderCosts['taxes'],
          ),
          orderCosts['discount'] != '0'
              ? OrderDetailsBillingItem(
                  title: "Promotion",
                  amount: orderCosts['discount'],
                  negative: true,
                )
              : Container(),
          orderCosts['freshOkCredits'] != '0'
              ? OrderDetailsBillingItem(
                  title: "freshOk Credits",
                  amount: orderCosts['freshOkCredits'],
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
                    text: AppTheme.currencySymbol + orderCosts['grandTotal'],
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
                    text: AppTheme.currencySymbol + orderCosts['savings'],
                    color: AppTheme.primaryColor,
                    fontSize: AppTheme.extraSmallTextSize,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 5 + measure.screenHeight * 0.01),
        ],
      ),
    );
  }
}

class OrderDetailsBillingItem extends StatelessWidget {
  final String title;
  final dynamic amount;
  final bool negative;
  const OrderDetailsBillingItem({
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
