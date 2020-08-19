import 'package:flutter/material.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';

class RegularText extends StatelessWidget {
  final String text;
  final Color color;
  final int fontSize;
  final FontWeight fontWeight;
  final TextDecoration decoration;
  final bool overflow;
  final TextAlign textAlign;
  final FontStyle fontStyle;
  final int maxLines;

  const RegularText({
    @required this.text,
    @required this.color,
    @required this.fontSize,
    this.fontWeight,
    this.decoration,
    this.overflow,
    this.textAlign,
    this.fontStyle,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Text(
      text,
      style: AppTheme.style.copyWith(
        color: color,
        fontSize: fontSize * measure.fontRatio,
        fontWeight: fontWeight ?? FontWeight.w400,
        decoration: decoration,
        fontStyle: fontStyle,
      ),
      maxLines: maxLines ?? null,
      overflow:
          overflow != false ? TextOverflow.ellipsis : TextOverflow.visible,
      textAlign: textAlign ?? TextAlign.left,
    );
  }
}
