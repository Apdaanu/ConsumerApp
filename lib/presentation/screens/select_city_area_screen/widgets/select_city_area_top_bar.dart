import 'package:flutter/material.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';

class SelectCityAreaTopBar extends StatelessWidget {
  final String title;
  final bool noBack;
  final String actionName;
  final actionFxn;
  final backAlt;

  const SelectCityAreaTopBar({
    Key key,
    @required this.actionName,
    @required this.actionFxn,
    @required this.title,
    this.noBack,
    this.backAlt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    bool noBackRes = noBack == true;
    return Container(
      height: measure.topBarHeight,
      padding: EdgeInsets.symmetric(horizontal: 5 + measure.width * 0.01),
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: noBackRes
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceBetween,
            children: <Widget>[
              noBackRes
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        if (backAlt != null) {
                          backAlt();
                          return;
                        }
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.keyboard_backspace,
                        color: AppTheme.black5,
                        size: 20 * measure.fontRatio,
                      ),
                    ),
              RegularText(
                text: title,
                color: AppTheme.black5,
                fontSize: AppTheme.regularTextSize,
                fontWeight: FontWeight.w500,
              ),
              noBackRes
                  ? Container()
                  : Icon(
                      Icons.keyboard_backspace,
                      color: Colors.transparent,
                      size: 20 * measure.fontRatio,
                    ),
            ],
          ),
          actionName != null
              ? Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      actionFxn();
                    },
                    child: RegularText(
                      text: actionName,
                      color: AppTheme.black3,
                      fontSize: AppTheme.smallTextSize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
