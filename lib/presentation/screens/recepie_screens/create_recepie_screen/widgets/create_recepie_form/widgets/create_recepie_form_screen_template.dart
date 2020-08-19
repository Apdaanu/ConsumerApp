import 'package:flutter/material.dart';
import 'package:freshOk/core/constants/measure.dart';

import '../../create_recepie_message_indicator.dart';

class CreateRecepieFormScreenTemplate extends StatelessWidget {
  final Widget child;

  const CreateRecepieFormScreenTemplate({Key key, @required this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      height: measure.bodyHeight - 15,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CreateRecepieMessageIndicator(),
            child,
            SizedBox(height: measure.topBarHeight + 15),
            SizedBox(height: 5 + measure.screenHeight * 0.01),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }
}
