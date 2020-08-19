import 'package:flutter/material.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/presentation/screens/order_screens/order_details/widgets/order_details_section_container.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';

import '../../../../../core/constants/measure.dart';

const orderStatusStates = [
  'Pending',
  'Accepted',
  'Packed',
  'Dispatched',
  'Delivered to mitra',
  'Delivered'
];

const titles = {
  'Pending': 'Order Placed',
  'Accepted': 'Order Confirmed',
  'Packed': 'Order Packed',
  'Dispatched': 'Order Dispatched',
  'Delivered to mitra': 'Delivered to freshMitra',
  'Delivered': 'Order Delivered',
  'Cancelled by team': 'Order Cancelled',
  'Cancelled by mitra': 'Order Cancelled',
  'Cancelled by user': 'Order Cancelled',
};

const messages = {
  'Pending': 'We have recieved your order',
  'Accepted': 'Your order has been confirmed',
  'Packed': 'Your order has been packed',
  'Dispatched': 'Your order is out of our warehouse',
  'Delivered to mitra': 'Your mitra has recieved the order',
  'Delivered': 'Yippie, sucessfully delivered!',
  'Cancelled by team': 'We were unable to process your order',
  'Cancelled by mitra': 'Your mitra was unable to process your order',
  'Cancelled by user': 'You cancelled this order',
};

const titlesAlt = {
  'Accepted': 'Processing Order',
  'Packed': 'Packing your order',
  'Dispatched': 'Dispatching',
  'Delivered to mitra': 'Delivering to mitra',
  'Delivered': 'Order is on the way',
};

const messagesAlt = {
  'Accepted': 'We are processing your orders',
  'Packed': 'Your order is being packed',
  'Dispatched': 'Dispatching...',
  'Delivered to mitra': 'Delivering to mitra',
  'Delivered': 'Will reach to you shortly',
};

class OrderDetailsProgressSteps extends StatefulWidget {
  final List orderStatus;

  const OrderDetailsProgressSteps({
    Key key,
    @required this.orderStatus,
  }) : super(key: key);

  @override
  _OrderDetailsProgressStepsState createState() =>
      _OrderDetailsProgressStepsState();
}

class _OrderDetailsProgressStepsState extends State<OrderDetailsProgressSteps> {
  List<Widget> _renderSteps(List steps) {
    print('[dbg] : ${steps}');
    List<Widget> list = List<Widget>();
    final latestStep = steps[steps.length - 1];
    bool reachedEnd = latestStep == 'Delivered' ||
        latestStep == 'Cancelled by team' ||
        latestStep == 'Cancelled by mitra' ||
        latestStep == 'Cancelled by user';

    if (steps.length == 1) {
      return [
        CustomStepper(
          title: titles[steps[0]],
          detail: messages[steps[0]],
          start: true,
        ),
        CustomStepper(
          title: titlesAlt[orderStatusStates[1]],
          detail: messagesAlt[orderStatusStates[1]],
          inProgressLine: true,
          inProgressText: true,
        )
      ];
    }

    for (int i = 0; i < steps.length; ++i) {
      if (i == 0) {
        list.add(CustomStepper(
          title: titles[steps[i]],
          detail: messages[steps[i]],
          start: true,
        ));
        continue;
      }
      if (i == steps.length - 1) {
        if (reachedEnd) {
          if (latestStep == 'Cancelled by mitra' ||
              latestStep == 'Cancelled by user' ||
              latestStep == 'Cancelled by team') {
            list.add(CustomStepper(
              title: titles[steps[i]],
              detail: messages[steps[i]],
              isCancelled: true,
            ));
          } else {
            list.add(CustomStepper(
              title: titles[steps[i]],
              detail: messages[steps[i]],
            ));
          }
          continue;
        } else {
          list.add(CustomStepper(
            title: titles[steps[i]],
            detail: messages[steps[i]],
          ));
          list.add(CustomStepper(
            title: titlesAlt[
                orderStatusStates[orderStatusStates.indexOf(steps[i]) + 1]],
            detail: messagesAlt[
                orderStatusStates[orderStatusStates.indexOf(steps[i]) + 1]],
            inProgressLine: true,
            inProgressText: true,
          ));
          continue;
        }
      }
      list.add(CustomStepper(
        title: titles[steps[i]],
        detail: messages[steps[i]],
      ));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return OrderDetailsSectionContainer(
      child: Column(
        children: <Widget>[
          SizedBox(height: 20 + measure.screenHeight * 0.02),
          Column(
            children: _renderSteps(widget.orderStatus),
          ),
          SizedBox(height: 20 + measure.screenHeight * 0.02),
        ],
      ),
    );
  }
}

class CustomStepper extends StatelessWidget {
  final String title;
  final String detail;
  final bool start;
  final bool inProgressText;
  final bool inProgressLine;
  final bool isCancelled;

  const CustomStepper({
    Key key,
    @required this.title,
    @required this.detail,
    this.start,
    this.inProgressText,
    this.inProgressLine,
    this.isCancelled,
  }) : super(key: key);

  Widget renderConnectionLine(measure) {
    if (start == true) return Container();
    var lineHeight = 30 + measure.screenHeight * 0.02;
    if (inProgressLine == true)
      return Container(
        child: Column(
          children: <Widget>[
            Container(
              height: (lineHeight) / 6,
              width: 3,
              color: AppTheme.orderDetailsYellow,
            ),
            SizedBox(height: 3),
            Container(
              height: (lineHeight) / 6,
              width: 3,
              color: AppTheme.orderDetailsYellow,
            ),
            SizedBox(height: 3),
            Container(
              height: (lineHeight) / 6,
              width: 3,
              color: AppTheme.orderDetailsYellow,
            ),
            SizedBox(height: 3),
            Container(
              height: (lineHeight) / 6,
              width: 3,
              color: AppTheme.orderDetailsYellow,
            ),
            SizedBox(height: 3),
            Container(
              height: (lineHeight) / 6,
              width: 3,
              color: AppTheme.orderDetailsYellow,
            ),
            SizedBox(height: 3),
            Container(
              height: (lineHeight) / 6,
              width: 3,
              color: AppTheme.orderDetailsYellow,
            ),
          ],
        ),
      );
    return Container(
      height: 45 + measure.screenHeight * 0.02,
      width: 3,
      color:
          isCancelled == true ? AppTheme.cartRed : AppTheme.orderDetailsGreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        SizedBox(width: 20 + measure.width * 0.01),
        Column(
          children: <Widget>[
            SizedBox(height: 2),
            renderConnectionLine(measure),
            SizedBox(height: 2),
            // CircleAvatar(
            //   backgroundColor: isCancelled == true
            //       ? AppTheme.cartRed
            //       : inProgressText == true
            //           ? AppTheme.orderDetailsYellow
            //           : AppTheme.orderDetailsGreen,
            //   radius: 3 + measure.width * 0.01,
            // ),
            Icon(
              isCancelled == true
                  ? Icons.error
                  : inProgressText == true
                      ? Icons.play_circle_filled
                      : Icons.check_circle,
              color: isCancelled == true
                  ? AppTheme.cartRed
                  : inProgressText == true
                      ? AppTheme.orderDetailsYellow
                      : AppTheme.orderDetailsGreen,
              size: 16 * measure.fontRatio,
            )
          ],
        ),
        SizedBox(width: 40 + measure.width * 0.02),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            RegularText(
              text: title,
              color: isCancelled == true
                  ? AppTheme.cartRed
                  : inProgressText == true
                      ? AppTheme.orderDetailsYellow
                      : AppTheme.black2,
              fontSize: AppTheme.regularTextSize,
            ),
            SizedBox(
              width: measure.width -
                  (20 * measure.width * 0.01) -
                  (20 + measure.width * 0.01) -
                  (6 + measure.width * 0.02) -
                  (40 + measure.width * 0.02),
              child: RegularText(
                text: detail,
                color: isCancelled == true
                    ? AppTheme.cartRed
                    : inProgressText == true
                        ? AppTheme.orderDetailsYellow
                        : AppTheme.black7,
                fontSize: AppTheme.smallTextSize,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
