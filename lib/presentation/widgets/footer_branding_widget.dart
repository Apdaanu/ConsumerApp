import 'package:flutter/material.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';

class FooterBrandingWidget extends StatelessWidget {
  const FooterBrandingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      width: measure.width,
      child: Column(
        children: <Widget>[
          Center(
            child: Text(
              "freshok.in",
              style: AppTheme.style.copyWith(
                color: AppTheme.orange,
                fontSize: 10 * measure.fontRatio,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: measure.screenHeight * 0.00),
          Center(
            child: Text(
              "Agritech end to end supply chain",
              style: AppTheme.style.copyWith(
                color: Colors.grey[400],
                fontSize: 8 * measure.fontRatio,
              ),
            ),
          ),
          SizedBox(height: measure.screenHeight * 0.005),
          Container(
            height: measure.screenHeight * 0.007,
            decoration: BoxDecoration(gradient: AppTheme.gradientAlt),
          )
        ],
      ),
    );
  }
}
