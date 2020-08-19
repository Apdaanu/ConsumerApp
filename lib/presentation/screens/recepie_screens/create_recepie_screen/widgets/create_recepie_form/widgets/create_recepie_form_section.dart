import 'package:flutter/material.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';

class CreateRecepieFormSection extends StatelessWidget {
  final String title;
  final Widget child;
  final bool req;
  const CreateRecepieFormSection({
    Key key,
    @required this.title,
    @required this.child,
    this.req,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5 + measure.width * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 15 + measure.screenHeight * 0.02),
          Row(
            children: <Widget>[
              RegularText(
                text: title,
                color: AppTheme.black2,
                fontSize: AppTheme.headingTextSize,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(width: 4),
              req != false
                  ? RegularText(
                      text: "*",
                      color: AppTheme.cartRed,
                      fontSize: AppTheme.headingTextSize,
                      fontWeight: FontWeight.bold,
                    )
                  : Container(),
            ],
          ),
          child,
        ],
      ),
    );
  }
}
