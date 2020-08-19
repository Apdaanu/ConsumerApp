import 'package:flutter/material.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/presentation/widgets/error_widget.dart';

class DisplayScreen extends StatelessWidget {
  final Widget topBar;
  final Widget body;
  final bool failure;
  final int failureCode;

  const DisplayScreen({
    Key key,
    this.topBar,
    @required this.body,
    @required this.failure,
    @required this.failureCode,
  })  : assert(body != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsets.only(top: measure.statusBarHeight),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: topBar != null
                  ? EdgeInsets.only(top: measure.topBarHeight)
                  : EdgeInsets.zero,
              child: body,
            ),
            topBar ?? Container(),
            if (failure)
              CustomErrorWidget(
                errCode: failureCode,
              )
            else
              Container()
          ],
        ),
      ),
    );
  }
}
