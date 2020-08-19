import 'package:flutter/material.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';

class CustomTextFieldUnderline extends StatelessWidget {
  final String hintText;
  final double underlineHeight;
  final int maxLines;
  final bool center;
  final EdgeInsets padding;
  final int fontSize;
  final FontWeight fontWeight;
  final bool enabled;
  final TextEditingController controller;
  final Color color;
  final onChanged;
  final bool autofocus;
  final FocusNode focusNode;
  final onSubmit;
  final int minLines;

  const CustomTextFieldUnderline({
    Key key,
    @required this.hintText,
    this.underlineHeight,
    this.maxLines,
    this.center,
    this.padding,
    this.fontSize,
    this.fontWeight,
    this.enabled,
    this.controller,
    this.color,
    this.onChanged,
    this.autofocus,
    this.focusNode,
    this.onSubmit,
    this.minLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Column(
      children: <Widget>[
        TextField(
          focusNode: focusNode,
          onChanged: (value) {
            if (onChanged != null) {
              onChanged(value);
            }
          },
          onSubmitted: (value) {
            if (this.onSubmit != null) onSubmit(value);
          },
          cursorColor: AppTheme.black3,
          controller: controller,
          autofocus: autofocus == true ? true : false,
          cursorWidth: 2,
          maxLines: maxLines ?? 1,
          minLines: minLines ?? 1,
          enabled: enabled ?? true,
          decoration: new InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            contentPadding: padding ?? EdgeInsets.zero,
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: "Open Sans",
              fontSize:
                  (fontSize ?? AppTheme.smallTextSize) * measure.fontRatio,
              fontWeight: fontWeight ?? FontWeight.w400,
              color: Colors.grey[400],
            ),
          ),
          style: TextStyle(
            fontFamily: "Open Sans",
            fontSize: (fontSize ?? AppTheme.smallTextSize) * measure.fontRatio,
            fontWeight: fontWeight ?? FontWeight.w400,
            color: AppTheme.black2,
          ),
          textAlign: center == true ? TextAlign.center : TextAlign.left,
        ),
        Container(
          height: underlineHeight ?? 2,
          color: color ?? AppTheme.primaryColor,
        )
      ],
    );
  }
}
