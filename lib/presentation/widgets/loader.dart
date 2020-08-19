import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/constants/measure.dart';

class CustomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Column(
      children: List.generate(
        6,
        (index) => Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          height: measure.screenHeight * 0.1,
          width: measure.width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[200],
            period: Duration(milliseconds: 2000 + 10 * index),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
