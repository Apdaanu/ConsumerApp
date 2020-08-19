import 'package:flutter/material.dart';
import 'package:freshOk/core/constants/measure.dart';

class OrderDetailsSectionContainer extends StatelessWidget {
  final Widget child;

  const OrderDetailsSectionContainer({Key key, @required this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      width: measure.width * 0.98 - 20,
      margin: EdgeInsets.symmetric(horizontal: 10 + measure.width * 0.01),
      padding: EdgeInsets.symmetric(horizontal: 10 + measure.width * 0.01),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 1,
            offset: Offset(0, 0),
            color: Color(0x29000000),
          )
        ],
        border: Border.all(
          width: 0.1,
          color: Color(0xff707070),
        ),
      ),
      child: child,
    );
  }
}
