import 'package:flutter/material.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/presentation/widgets/card_shimmer.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';

class OrderDetailsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        SizedBox(height: 20),
        Center(
          child: ShimmerContainer(
            child: RegularText(
              text: 'Placed on 01 Jan, 12:00 am',
              color: Colors.grey,
              fontSize: AppTheme.smallTextSize,
            ),
          ),
        ),
        SizedBox(height: 20),
        Column(
          children: List.generate(8, (index) => CardShimmer(lag: index * 10)),
        )
      ],
    );
  }
}
