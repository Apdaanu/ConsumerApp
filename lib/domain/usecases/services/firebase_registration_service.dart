import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freshOk/domain/repositories/firebase/firebase_registration_token_repository.dart';
import 'package:freshOk/main.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}

class FirebaseRegistrationService {
  final FirebaseMessaging firebaseMessaging;
  final FirebaseRegistrationTokenRepository repository;

  FirebaseRegistrationService({
    @required this.firebaseMessaging,
    @required this.repository,
  });

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  int index = 0;

  _navigateToItemDetail(message) async {
    navigatorKey.currentState.pushNamed(message['data']['route']);
  }

  Future<void> init() {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          'your channel description',
          importance: Importance.Max,
          priority: Priority.High,
          ticker: 'ticker',
        );
        var iOSPlatformChannelSpecifics = IOSNotificationDetails();
        var platformChannelSpecifics = NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        flutterLocalNotificationsPlugin.show(
          this.index,
          message['notification']['title'],
          message['notification']['body'],
          platformChannelSpecifics,
          payload: message['data']['route'],
        );
        this.index += 1;
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _navigateToItemDetail(message);
      },
    );
    return null;
  }

  Future<void> postRegistrationToken(String userId) async {
    await firebaseMessaging.getToken().then((token) async {
      print('[dbg] : $token');
      final failureOrSuccess = await repository.postToken(
        token: token,
        userId: userId,
      );
      failureOrSuccess.fold(
        (failure) {
          print('[err] : Failed to post firebase token');
        },
        (success) {
          print('[sys] : firebase token posted');
        },
      );
    });
    return null;
  }
}
