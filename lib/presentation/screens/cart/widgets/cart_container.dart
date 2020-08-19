import 'package:flutter/material.dart';
import 'package:freshOk/core/constants/measure.dart';

class CartContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final List<BoxShadow> boxShadow;
  final Border border;
  final bool noPadding;

  const CartContainer({
    Key key,
    @required this.child,
    this.color,
    this.boxShadow,
    this.border,
    this.noPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        width: measure.width * 0.96 - 8,
        padding: noPadding != true
            ? EdgeInsets.only(
                top: 5 + measure.screenHeight * 0.01,
                bottom: 5 + measure.screenHeight * 0.01,
                left: 5 + measure.width * 0.01,
                right: 5 + measure.width * 0.01,
              )
            : EdgeInsets.symmetric(horizontal: 5 + measure.width * 0.01),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: boxShadow ?? [],
          border: border ?? null,
          borderRadius: BorderRadius.circular(2),
        ),
        child: child,
      ),
    );
  }
}
