import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../../../presentation/widgets/regular_text.dart';

class DialogService {
  static void display({
    @required BuildContext context,
    @required String title,
    @required String content,
    List<Widget> actions,
  }) {
    showDialog(
      context: context,
      child: new AlertDialog(
        title: new RegularText(
          text: title,
          color: AppTheme.black2,
          fontSize: AppTheme.headingTextSize,
          fontWeight: FontWeight.bold,
          overflow: false,
        ),
        content: new RegularText(
          text: content,
          color: AppTheme.black5,
          fontSize: AppTheme.regularTextSize,
          overflow: false,
        ),
        actions: actions,
        scrollable: true,
      ),
    );
  }
}
