import 'package:flutter/material.dart';
import 'package:freshOk/domain/entities/order/order.dart';

import '../../../../../core/constants/measure.dart';
import '../../../../widgets/fresh_mitra_with_phone.dart';
import 'order_details_section_container.dart';

class OrderDetailsFreshMitra extends StatelessWidget {
  final bool border;
  final MitraDetails mitraDetails;

  const OrderDetailsFreshMitra({
    Key key,
    this.border,
    this.mitraDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return OrderDetailsSectionContainer(
      child: FreshMitraWithPhone(
        mitraDetails: mitraDetails,
      ),
    );
  }
}
