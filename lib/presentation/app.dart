import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/constants/routes.dart';
import '../core/usecases/usecase.dart';
import '../domain/entities/basic_user.dart';
import '../domain/usecases/services/authentication_service.dart';
import '../domain/usecases/services/dynamic_link_service.dart';
import '../domain/usecases/services/firebase_registration_service.dart';
import '../domain/usecases/services/flutter_local_notif_service.dart';
import '../injection_container.dart';
import 'widgets/splash_screen.dart';

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  AuthenticationService _authenticationService;
  FirebaseRegistrationService _firebaseRegistrationService;
  FlutterLocalNotifService _flutterLocalNotifService;
  DynamicLinkService _dynamicLinkService;

  @override
  void initState() {
    super.initState();
    _authenticationService = sl<AuthenticationService>();
    _firebaseRegistrationService = sl<FirebaseRegistrationService>();
    _flutterLocalNotifService = sl<FlutterLocalNotifService>();
    _dynamicLinkService = sl<DynamicLinkService>();

    _firebaseRegistrationService.init();
    _flutterLocalNotifService.init();
    _dynamicLinkService.initDynamicLinks();
    _bootScript();
  }

  void _bootScript() async {
    print('[sys] : booting into the system');
    final failureOrBasicUser = await _authenticationService(NoParams());
    failureOrBasicUser.fold((failure) {
      print('[err] : failed to boot : ${failure.code}');
      switch (failure.code) {
        case 200:
          print('[sys] : Nav to phone screen');
          Navigator.pushReplacementNamed(context, phoneRoute);
          break;
        case 100:
          print('[err] : Server cannot be reached');
          break;
        case 300:
          print('[err] : Device not connected to the internet');
          break;
        default:
      }
    }, (basicUserRes) async {
      print('[sys] : booted into the system');
      BasicUser basicUser = basicUserRes;
      if (basicUser.newUser) {
        print('[sys] : new user, please register');
        Navigator.pushReplacementNamed(context, registerRoute);
      } else {
        print('[sys] : existnig user, directing to home page');
        Navigator.pushReplacementNamed(context, homeRoute, arguments: 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreen(),
    );
  }
}
