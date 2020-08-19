import "package:flutter/material.dart";
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/error/input_error.dart';
import 'package:freshOk/core/theme/theme.dart';

class CustomDropdown extends StatelessWidget {
  final List<dynamic> objs;
  final bool loading;
  final String val;
  final onChange;
  final String title;
  final FocusNode focus;
  final bool err;
  final String errMsg;

  const CustomDropdown({
    Key key,
    @required this.objs,
    @required this.loading,
    @required this.val,
    @required this.onChange,
    @required this.title,
    this.focus,
    this.err,
    this.errMsg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);

    var borderColor =
        err != null && err ? AppTheme.redCancel : AppTheme.primaryColor;
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 7),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: borderColor),
                borderRadius: BorderRadius.circular(5),
              ),
              child: new DropdownButton<dynamic>(
                icon: Icon(Icons.arrow_drop_down, color: borderColor),
                focusNode: focus,
                hint: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: measure.width * 0.04),
                  child: Text(
                    'Select $title',
                    style: AppTheme.style.copyWith(
                      fontSize: 12 * measure.fontRatio,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                items: loading
                    ? [
                        DropdownMenuItem(
                          value: null,
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: measure.width * 0.04),
                              child: Text('Loading ...',
                                  style: AppTheme.style.copyWith(
                                      fontSize: 12 * measure.fontRatio,
                                      color: Colors.grey[500]))),
                        )
                      ]
                    : objs
                        .map<DropdownMenuItem>((c) => DropdownMenuItem(
                              value: c.id,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: measure.width * 0.04),
                                child: Text(c.name,
                                    style: AppTheme.style.copyWith(
                                        fontSize: 12 * measure.fontRatio)),
                              ),
                            ))
                        .toList(),
                value: loading ? null : val,
                isExpanded: true,
                onChanged: onChange,
                underline: Container(height: 0),
              ),
            ),
            if (err != null && err)
              Column(
                children: <Widget>[
                  Text(
                    errMsg,
                    style: AppTheme.style.copyWith(
                      color: AppTheme.redCancel,
                      fontSize: 10 * measure.fontRatio,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: measure.bodyHeight * 0.02),
                ],
              )
            else
              Text(""),
            SizedBox(height: measure.bodyHeight * 0.01),
          ],
        ),
        Positioned(
          top: -2,
          left: 10,
          child: Container(
            color: Color(0xfffafafa),
            child: Text(
              "  $title  ",
              style: AppTheme.style.copyWith(
                fontSize: 10 * measure.fontRatio,
                fontWeight: FontWeight.w700,
                color: borderColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
