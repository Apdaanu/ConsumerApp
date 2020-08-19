import 'package:flutter/cupertino.dart';

abstract class Measure {
  double get statusBarHeight;
  double get topBarHeight;
  double get height;
  double get width;
  double get fontRatio;
  double get bodyHeight;
  double get screenHeight;
  double get keyboardHeight;
}

class MeasureImpl implements Measure {
  final context;

  MeasureImpl(this.context);

  double get statusBarHeight => MediaQuery.of(context).padding.top;

  double get topBarHeight => (50 + MediaQuery.of(context).size.height * 0.01);

  double get height => MediaQuery.of(context).size.height;

  double get width => MediaQuery.of(context).size.width;

  double get fontRatio => this.height * 0.0002 + 1;

  double get bodyHeight =>
      this.height - this.topBarHeight - this.statusBarHeight;

  double get screenHeight => this.height - this.statusBarHeight;

  double get keyboardHeight => MediaQuery.of(context).viewInsets.bottom;
}
