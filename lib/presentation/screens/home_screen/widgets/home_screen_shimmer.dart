import 'package:flutter/material.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/measure.dart';

const cats = [
  'Mango: The King',
  'An Apple A Day',
  'Cauli-Fowers',
  'Bitter-Sweetness',
  'freshOk Favourites',
  'C C Carrot',
  'Berries',
  'Essentails',
];

class HomeScreenShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Column(
      children: <Widget>[
        Shimmer.fromColors(
          child: Container(
            width: measure.width,
            height: measure.width * (5 / 16),
            color: Colors.grey,
          ),
          baseColor: Colors.grey[300],
          highlightColor: Colors.white,
          period: Duration(milliseconds: 800),
        ),
        CategoryShimmer(idx: 0, lag: 0),
        CategoryShimmer(idx: 4, lag: 10),
      ],
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  final int lag;
  final int idx;
  const CategoryShimmer({
    Key key,
    this.lag = 0,
    this.idx = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.white,
        period: Duration(milliseconds: 810 + lag),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            4,
            (index) => Container(
              width: measure.width * 0.25,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              child: Column(
                children: <Widget>[
                  Container(
                    height: measure.width * 0.25 - 10,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  RegularText(
                    text: cats[idx + index],
                    color: Colors.grey,
                    fontSize: AppTheme.regularTextSize,
                    overflow: false,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
