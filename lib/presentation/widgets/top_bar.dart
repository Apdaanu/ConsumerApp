import 'package:flutter/material.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';

class CustomTopBar extends StatelessWidget {
  final bool lightTheme;
  final String title;
  final Widget action;
  final EdgeInsets padding;
  final altBackFxn;

  const CustomTopBar({
    Key key,
    this.lightTheme,
    @required this.title,
    this.action,
    this.padding,
    this.altBackFxn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    final Color bgColor = lightTheme == true ? Colors.white : AppTheme.homeBlue;
    final Color textColor = lightTheme == true ? AppTheme.black2 : Colors.white;

    return Container(
      height: measure.topBarHeight,
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: 1 + measure.width * 0.01),
      decoration: BoxDecoration(
        color: bgColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Material(
                borderRadius: BorderRadius.circular(40),
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (altBackFxn != null) {
                      altBackFxn();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  borderRadius: BorderRadius.circular(40),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.keyboard_backspace,
                      color: textColor,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15 + measure.width * 0.03),
              RegularText(
                text: title,
                color: textColor,
                fontSize: AppTheme.headingTextSize,
              ),
            ],
          ),
          action != null ? action : Container(),
        ],
      ),
    );
  }
}
