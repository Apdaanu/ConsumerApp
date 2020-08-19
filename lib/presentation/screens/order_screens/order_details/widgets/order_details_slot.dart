import 'package:flutter/material.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/core/util/util.dart';
import 'package:freshOk/presentation/screens/order_screens/order_details/widgets/order_details_section_container.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';

import '../../../../../domain/entities/order/book_slot.dart';

class OrderDetailsSlot extends StatelessWidget {
  final Slots slot;
  final String slotDate;
  final String status;

  const OrderDetailsSlot({
    Key key,
    this.slot,
    this.slotDate,
    this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);

    final date = Util.getDateFromUTC(slotDate);
    if (status == 'Cancelled by user' ||
        status == 'Cancelled by mitra' ||
        status == 'Cancelled by team')
      return Container();
    else
      return Column(
        children: <Widget>[
          SizedBox(height: 10 + measure.screenHeight * 0.01),
          OrderDetailsSectionContainer(
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: 5 + measure.screenHeight * 0.01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RegularText(
                    text: status != 'DELIVERED'
                        ? 'EXPECTED DELIVERY'
                        : 'DELIVERY DATE',
                    color: AppTheme.black5,
                    fontSize: AppTheme.regularTextSize,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 10),
                  RegularText(
                    text: date['date'] +
                        ', ' +
                        slot.startTime +
                        ' to ' +
                        slot.endTime,
                    color: AppTheme.black2,
                    fontSize: AppTheme.regularTextSize,
                  )
                ],
              ),
            ),
          ),
        ],
      );
  }
}
