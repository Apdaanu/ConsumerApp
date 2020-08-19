import 'package:flutter/material.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/presentation/widgets/card_shimmer.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';
import 'package:shimmer/shimmer.dart';

class RecepieDetailShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Column(
      children: <Widget>[
        ShimmerContainer(
          child: Container(
            width: measure.width,
            height: measure.width * 0.75,
            color: Colors.grey,
          ),
        ),
        ShimmerContainer(
          lag: 10,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.favorite,
                  color: Colors.grey,
                  size: 24 * measure.fontRatio,
                ),
                RegularText(
                  text: '12.2K',
                  color: Colors.grey,
                  fontSize: AppTheme.regularTextSize,
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: CardShimmer(lag: 20),
        ),
        SizedBox(height: 20),
        ShimmerContainer(
          lag: 30,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: RegularText(
                text:
                    "The early recipes of pound cake called for one pound of butter, one pound of eggs, and one pound of sugar. That’s a huge cake!",
                color: Colors.grey,
                fontSize: AppTheme.regularTextSize,
                overflow: false,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        ShimmerContainer(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              3,
              (index) => Column(
                children: <Widget>[
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    alignment: Alignment.center,
                    child: RegularText(
                      text: '100/100',
                      color: Colors.grey,
                      fontSize: AppTheme.regularTextSize,
                    ),
                  ),
                  SizedBox(height: 10),
                  RegularText(
                    text: 'DELICIOUS',
                    color: Colors.grey,
                    fontSize: AppTheme.regularTextSize,
                    fontWeight: FontWeight.bold,
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
