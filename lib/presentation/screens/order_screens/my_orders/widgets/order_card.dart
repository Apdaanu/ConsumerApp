import 'package:flutter/material.dart';
import 'package:freshOk/core/util/util.dart';
import 'package:freshOk/domain/entities/order/order.dart';

import '../../../../../core/constants/measure.dart';
import '../../../../../core/constants/routes.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../widgets/regular_text.dart';

final colorMap = {
  'Pending': Color(0xffF7AE18),
  'Accepted': Color(0xff26A967),
  'Packed': Color(0xffF7AE18),
  'Dispatched': Color(0xffF7AE18),
  'Delivered to mitra': Color(0xff563e7b),
  'Delivered': Color(0xff563e7b),
  'Cancelled by team': Color(0xffe76450),
  'Cancelled by mitra': Color(0xffe76450),
  'Cancelled by user': Color(0xffe76450),
};

class OrderCard extends StatelessWidget {
  final Order order;
  const OrderCard({
    Key key,
    @required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          orderDetailsRoute,
          arguments: order.id,
        );
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 5 + measure.screenHeight * 0.01,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: 5 + measure.width * 0.02,
              vertical: 2 + measure.screenHeight * 0.01,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  offset: Offset(0, 0),
                  blurRadius: 1,
                  color: Color(0x29000000),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                OrderCardHeader(
                  date: order.orderDate,
                  status: order.orderStatus[order.orderStatus.length - 1],
                ),
                SizedBox(height: 10 + measure.screenHeight * 0.01),
                OrderCardBody(
                  orderId: order.orderId,
                  payMethod: order.paymentMethod,
                  totalAmount: Util.getMoneyValuesFromOrder(
                    coupon: order.discount,
                    deliveryCharges: order.deliveryCharges,
                    order: order.order,
                    usedFreshOkCredit: order.usedFreshOkCredit,
                  )['grandTotal'],
                ),
              ],
            ),
          ),
          Container(
            width: measure.width,
            padding: EdgeInsets.symmetric(horizontal: 5 + measure.width * 0.02),
            alignment: Alignment.centerRight,
            child: RegularText(
              text: Util.getDateFromUTC(order.orderDate)['time'],
              color: AppTheme.black7,
              fontSize: AppTheme.smallTextSize,
            ),
          ),
          SizedBox(height: 5 + measure.screenHeight * 0.01)
        ],
      ),
    );
  }
}

class OrderCardBody extends StatelessWidget {
  final String orderId;
  final String payMethod;
  final String totalAmount;

  const OrderCardBody({
    Key key,
    @required this.orderId,
    @required this.payMethod,
    @required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5 + measure.width * 0.02),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: OrderCardHeadings(title: "Order Id"),
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.center,
                  child: OrderCardHeadings(title: "Pay Method"),
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: OrderCardHeadings(title: "Amount"),
                ),
              ),
            ],
          ),
          SizedBox(height: 5 + measure.screenHeight * 0.01),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 1,
                  color: AppTheme.black7,
                ),
              ),
            ),
          ),
          SizedBox(height: 5 + measure.screenHeight * 0.01),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RegularText(
                    text: orderId,
                    color: AppTheme.black2,
                    fontSize: AppTheme.smallTextSize,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.center,
                  child: RegularText(
                    text: payMethod == 'cod' ? 'Cash On Delivery' : Util.capitalize(payMethod),
                    color: AppTheme.black2,
                    fontSize: AppTheme.smallTextSize,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: RegularText(
                    text: "₹$totalAmount",
                    color: AppTheme.black2,
                    fontSize: AppTheme.smallTextSize,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderCardHeader extends StatelessWidget {
  final String date;
  final String status;
  const OrderCardHeader({
    Key key,
    @required this.date,
    @required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 5 + measure.width * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              OrderCardHeadings(title: "Date"),
              RegularText(
                text: Util.getDateFromUTC(date)['date'],
                color: AppTheme.black2,
                fontSize: AppTheme.headingTextSize,
              )
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 5 + measure.width * 0.02),
              child: OrderCardHeadings(title: "Status"),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10 + measure.width * 0.02,
                vertical: measure.screenHeight * 0.005,
              ),
              decoration: BoxDecoration(
                  color: colorMap[status],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(2),
                    bottomLeft: Radius.circular(2),
                  )),
              child: RegularText(
                text: status,
                color: Colors.white,
                fontSize: AppTheme.regularTextSize,
              ),
            )
          ],
        )
      ],
    );
  }
}

class OrderCardHeadings extends StatelessWidget {
  final String title;
  const OrderCardHeadings({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RegularText(
      text: title,
      color: AppTheme.black7,
      fontSize: AppTheme.extraSmallTextSize,
    );
  }
}
