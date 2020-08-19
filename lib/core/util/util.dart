import 'dart:math';

import 'package:flutter/material.dart';

import '../../domain/entities/order/coupon.dart';
import '../../domain/entities/order/delivery_charges.dart';
import '../../domain/entities/order/discount.dart';
import '../../domain/entities/referral/referral.dart';
import '../../main.dart';
import '../constants/routes.dart';

class Util {
  static String removeDecimalZeroFormat(var n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  static String capitalize(String s) {
    return s.replaceFirst(s[0], s[0].toUpperCase());
  }

  static int stringToUint(String s) {
    return int.parse(s);
  }

  static bool checkCorrectMob(String mob) {
    if (mob.substring(0, 1) == '0') {
      if (mob.length == 11) {
        return true;
      } else {
        return false;
      }
    } else {
      if (mob.length == 10) {
        return true;
      } else {
        return false;
      }
    }
  }

  static void subCategoryNavigationHandler({
    @required String type,
    @required String idType,
    @required String categoryId,
    @required String sectionId,
    @required String title,
    String whichPage,
    String recepieType,
  }) {
    switch (type) {
      case 'blank':
        print('[dbg] : No action specified');
        return;
        break;
      case 'link':
        print('[dbg] : link tapped');
        break;
      case 'id':
        if (idType == 'productCategory')
          navigatorKey.currentState.pushNamed(
            productListRoute,
            arguments: {
              'categoryId': categoryId,
              'sectionId': sectionId,
              'title': title,
            },
          );
        else if (idType == 'recipeCategory')
          navigatorKey.currentState.pushNamed(
            recepieListRoute,
            arguments: {
              'categoryId': categoryId,
              'sectionId': sectionId,
              'title': title,
              'whichPage': whichPage,
              'recepieType': recepieType,
            },
          );
        break;
      default:
        return;
    }
  }

  static Map<String, String> getDateFromUTC(String utc) {
    final todaysDate = DateTime.now();
    var localdate = DateTime.parse(utc).toLocal();
    Map<String, String> res = Map<String, String>();
    res['date'] = getMonthName(localdate.month) +
        ' ' +
        localdate.day.toString().padLeft(2, '0') +
        (todaysDate.year != localdate.year
            ? ' ' + localdate.year.toString()
            : '');
    String time;
// res['time'] = localdate.hour.toString().padLeft(2, '0') +
//         ':' +
//         localdate.minute.toString().padLeft(2, '0')

    if (localdate.hour == 0) {
      time = '12:' + localdate.minute.toString().padLeft(2, '0') + ' am';
    } else if (localdate.hour < 12) {
      time = localdate.hour.toString().padLeft(2, '0') +
          ':' +
          localdate.minute.toString().padLeft(2, '0') +
          ' am';
    } else if (localdate.hour == 12) {
      time = '12:' + localdate.minute.toString().padLeft(2, '0') + ' pm';
    } else {
      time = (localdate.hour - 12).toString().padLeft(2, '0') +
          ':' +
          localdate.minute.toString().padLeft(2, '0') +
          ' pm';
    }

    res['time'] = time;
    return res;
  }

  static Map<String, String> getDateFromTimeStamp(int ms) {
    var localdate = DateTime.fromMillisecondsSinceEpoch(ms);
    Map<String, String> res = Map<String, String>();
    res['date'] = localdate.day.toString().padLeft(2, '0') +
        ' ' +
        getMonthName(localdate.month) +
        ' ' +
        localdate.year.toString();
    String time;
// res['time'] = localdate.hour.toString().padLeft(2, '0') +
//         ':' +
//         localdate.minute.toString().padLeft(2, '0')
    if (localdate.hour < 12) {
      time = localdate.hour.toString().padLeft(2, '0') +
          ':' +
          localdate.minute.toString().padLeft(2, '0') +
          'am';
    }

    res['time'] = time;

    return res;
  }

  static String getMonthName(int m) {
    switch (m) {
      case 1:
        return 'Jan';
        break;
      case 2:
        return 'Feb';
        break;
      case 3:
        return 'Mar';
        break;
      case 4:
        return 'Apr';
        break;
      case 5:
        return 'May';
        break;
      case 6:
        return 'Jun';
        break;
      case 7:
        return 'Jul';
        break;
      case 8:
        return 'Aug';
        break;
      case 9:
        return 'Sep';
        break;
      case 10:
        return 'Oct';
        break;
      case 11:
        return 'Nov';
        break;
      case 12:
        return 'Dec';
        break;
      default:
        return '';
    }
  }

  static Map<String, String> getMoneyValuesFromOrder({
    List order,
    DeliveryCharges deliveryCharges,
    dynamic coupon,
    double usedFreshOkCredit,
  }) {
    double itemTotal = 0;
    double deliveryFee = 0;
    double taxes = 0;
    double discount = 0;
    double freshOkCredits = 0;
    double grandTotal = 0;
    double savings = 0;

    //Calculate item total
    order.forEach((element) {
      itemTotal += element.discountedPrice * element.quantity;
    });

    //Calculate delivery charges
    if (deliveryCharges.limit == 0) {
      if (coupon is Discount) {
        if (deliveryCharges.chargeType == '%') {
          deliveryFee = itemTotal * deliveryCharges.charges * 0.01;
        } else {
          deliveryFee = deliveryCharges.charges;
        }
      }
    } else {
      if (deliveryCharges.limit > itemTotal) {
        if (deliveryCharges.chargeType == '%') {
          deliveryFee = itemTotal * deliveryCharges.charges * 0.01;
        } else {
          deliveryFee = deliveryCharges.charges;
        }
      }
    }

    //Calclulate discount (from coupons)
    if (coupon != null) {
      if (coupon is Discount) {
        if (coupon.discountType == '%') {
          discount = itemTotal * coupon.discountValue * 0.01;
        } else {
          discount = coupon.discountValue;
        }
      } else if (coupon is Coupon) {
        if (coupon.type == 'delivery') {
          deliveryFee = 0;
        } else if (coupon.type == '%') {
          discount = itemTotal * coupon.properties.discount * 0.01;
        } else {
          discount = coupon.properties.discount;
        }
      }
    }

    freshOkCredits = min(usedFreshOkCredit, itemTotal);

    grandTotal = itemTotal + deliveryFee + taxes - discount - freshOkCredits;

    //calculate savings
    order.forEach((element) {
      savings +=
          (element.unitPrice - element.discountedPrice) * element.quantity;
    });
    savings += discount;
    savings += freshOkCredits;

    return {
      'itemTotal': removeDecimalZeroFormat(itemTotal),
      'deliveryFee': removeDecimalZeroFormat(deliveryFee),
      'taxes': removeDecimalZeroFormat(taxes),
      'discount': removeDecimalZeroFormat(discount),
      'freshOkCredits': removeDecimalZeroFormat(freshOkCredits),
      'grandTotal': removeDecimalZeroFormat(grandTotal),
      'savings': removeDecimalZeroFormat(savings),
    };
  }

  static String recepieTimeFormatter(int timeInMins) {
    if (timeInMins < 60) {
      return timeInMins.toString() + ' min';
    } else {
      return (timeInMins ~/ 60).toString() +
          ' h ' +
          (timeInMins % 60 > 0 ? (timeInMins % 60).toString() + ' min' : '');
    }
  }

  static String getTotalReferredAmount(Referral referral) {
    double amount = 0;
    referral.referrals.forEach((element) {
      amount += element.freshOkCredit;
    });
    return removeDecimalZeroFormat(amount);
  }

  static int getNumberOfDaysInAMonth(int year, int month) {
    if (month == 1 ||
        month == 3 ||
        month == 5 ||
        month == 7 ||
        month == 8 ||
        month == 10 ||
        month == 12) {
      return 31;
    } else if (month == 4 || month == 6 || month == 9 || month == 11) {
      return 30;
    } else if (year % 4 == 0 && month == 2) {
      return 29;
    } else {
      return 28;
    }
  }
}
