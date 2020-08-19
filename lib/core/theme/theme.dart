import 'dart:ui';

import 'package:flutter/material.dart';

class AppTheme {
  static Color primaryColor = getColorFromHex('#2ad1b5');
  static Color secondaryColor = getColorFromHex('#258db4');
  static Color redCancel = getColorFromHex("#ff8181");
  static Color mitraBlue = getColorFromHex("#465b75");
  static Color darkGreen = getColorFromHex("#0eb095");
  static Color lightGreen = getColorFromHex("#42e3c8");
  static Color orange = getColorFromHex("#fe661b");
  static Color homeBlue = getColorFromHex("#202A2E");
  static Color black3 = getColorFromHex("#363636");
  static Color black5 = getColorFromHex("#575757");
  static Color black7 = getColorFromHex("#777777");
  static Color black2 = getColorFromHex("#212121");
  static Color orderDetailsGreen = getColorFromHex("#26a967");
  static Color greyFB = getColorFromHex("#fbfbfb");
  static Color greyF5 = getColorFromHex("#f5f5f5");
  static Color borderBlack7 = Color(0xff707070);
  static Color orderDetailsYellow = getColorFromHex("#eb9c05");
  static Color cartOrange = getColorFromHex("#ff8b5c");
  static Color cartSecondary = getColorFromHex("249eb4");
  static Color cartRed = getColorFromHex("#f24d4d");
  static Color referGreen = getColorFromHex("#78c473");
  static Color recepiePlaceOrderOrange = getColorFromHex("#ff7541");

  static int regularTextSize = 12;
  static int smallTextSize = 10;
  static int extraSmallTextSize = 8;
  static int headingTextSize = 14;
  static int extraLargeHeading = 22;

  static String currencySymbol = "₹";

  static const style = TextStyle(fontFamily: "Open Sans");
  static final style_cp =
      TextStyle(fontFamily: "Open Sans", color: AppTheme.primaryColor);

  static LinearGradient gradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight, // 10% of the width, so there are ten blinds.
    colors: [getColorFromHex('#22d4b4'), getColorFromHex('#258db4')],
  );
  static LinearGradient gradientInverse = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight, // 10% of the width, so there are ten blinds.
    colors: [getColorFromHex('#258db4'), getColorFromHex('#22d4b4')],
  );
  static LinearGradient gradientAlt = LinearGradient(
    begin: Alignment(0.016437621787190437, 0.5887957215309143),
    end: Alignment(0.9455849528312684, 0.5887957215309143),
    colors: [const Color(0xfffe5858), const Color(0xffffbe60)],
  );
  static LinearGradient gradientAltInverse = LinearGradient(
    end: Alignment(0.016437621787190437, 0.5887957215309143),
    begin: Alignment(0.9455849528312684, 0.5887957215309143),
    colors: [const Color(0xfffe5858), const Color(0xffffbe60)],
  );
  static getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}
