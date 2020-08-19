import 'package:flutter/material.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';

class BrandingWidget extends StatelessWidget {
  const BrandingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);

    return Container(
      height: measure.screenHeight * 0.25,
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: measure.screenHeight * 0.05,
            ),
            Container(
              height: measure.screenHeight * 0.08,
              width: measure.screenHeight * 0.08,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(measure.screenHeight * 0.015),
                image: DecorationImage(
                  image: Image.asset('assets/images/icon.png').image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(
              'freshOk',
              style: AppTheme.style_cp.copyWith(
                fontSize: 18 * measure.fontRatio,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
