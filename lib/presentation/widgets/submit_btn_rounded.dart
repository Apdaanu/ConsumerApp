import 'package:flutter/material.dart';

import '../../core/constants/measure.dart';
import '../../core/theme/theme.dart';

class SubmitBtnRounded extends StatelessWidget {
  final bool loading;
  final onPressed;
  final Color color;
  final String value;
  final double radius;

  const SubmitBtnRounded({
    Key key,
    @required this.loading,
    @required this.onPressed,
    this.color,
    this.value,
    @required this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return RaisedButton(
      onPressed: () {
        if (loading) {
          return;
        }
        onPressed();
      },
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Text(
        value,
        style: AppTheme.style
            .copyWith(color: Colors.white, fontSize: 12 * measure.fontRatio),
      ),
    );
  }
}
