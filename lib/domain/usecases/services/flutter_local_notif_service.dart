import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freshOk/core/constants/routes.dart';
import 'package:freshOk/main.dart';

class FlutterLocalNotifService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  FlutterLocalNotifService(this.flutterLocalNotificationsPlugin);

  int index = 0;

  Future<void> init() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/notification_icon');
    var initializationSettingsIOS =
        IOSInitializationSettings(onDidReceiveLocalNotification: null);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: this.selectNotification);
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
      final decoded = await json.decode(payload);
      print('notification decoded: ' + decoded);
      switch (decoded['route']) {
        case orderDetailsRoute:
          print('[dbg] : order details route');
          navigatorKey.currentState.pushNamed(
            orderDetailsRoute,
            arguments: decoded['orderId'],
          );
          break;
        default:
      }
    }
  }

  Future<void> sendNotif({
    @required String title,
    @required String body,
    @required Map payload,
  }) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id : freshOk',
      'your channel name : freshOk',
      'your channel description : freshOk',
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker',
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(
      this.index,
      title,
      body,
      platformChannelSpecifics,
      payload: json.encode(payload),
    );
    this.index += 1;
  }
}
