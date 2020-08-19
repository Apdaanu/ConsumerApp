import 'package:flutter/material.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/core/util/util.dart';
import 'package:freshOk/presentation/screens/order_screens/order_details/widgets/order_details_section_container.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';

class OrderDetailsPaymentDetails extends StatelessWidget {
  final String paymentMethod;

  const OrderDetailsPaymentDetails({Key key, @required this.paymentMethod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return OrderDetailsSectionContainer(
      child: Padding(
        padding: EdgeInsets.symmetric(
          // horizontal: 20 + measure.width * 0.01,
          vertical: 5 + measure.screenHeight * 0.01,
        ),
        child: RegularText(
          text: paymentMethod == 'cod'
              ? 'Cash On Delivery'
              : Util.capitalize(paymentMethod),
          color: AppTheme.black2,
          fontSize: AppTheme.regularTextSize,
        ),
      ),
    );
  }
}
