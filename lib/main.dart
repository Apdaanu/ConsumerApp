import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/bottom_nav/bottom_nav_bloc.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/cart_bloc/cart_bloc.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/pop_lock_bloc/pop_lock_bloc.dart';

import 'injection_container.dart' as di;
import 'presentation/app.dart';
import 'presentation/routes/router.dart';
import 'presentation/screens/bottom_nav_holder/blocs/mitra_bloc/mitra_bloc.dart';
import 'presentation/screens/bottom_nav_holder/blocs/place_bloc/place_bloc.dart';
import 'presentation/screens/bottom_nav_holder/blocs/referral_bloc/referral_bloc.dart';
import 'presentation/screens/bottom_nav_holder/blocs/user_details_bloc/user_details_bloc.dart';

void main() async {
  await di.init();
  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UserDetailsBloc _userDetailsBloc;
  PlaceBloc _placeBloc;
  MitraBloc _mitraBloc;
  ReferralBloc _referralBloc;
  CartBloc _cartBloc;
  BottomNavBloc _bottomNavBloc;
  PopLockBloc _popLockBloc;

  @override
  void initState() {
    super.initState();
    _userDetailsBloc = di.sl<UserDetailsBloc>();
    _placeBloc = di.sl<PlaceBloc>();
    _mitraBloc = di.sl<MitraBloc>();
    _referralBloc = di.sl<ReferralBloc>();
    _cartBloc = di.sl<CartBloc>();
    _bottomNavBloc = di.sl<BottomNavBloc>();
    _popLockBloc = di.sl<PopLockBloc>();
  }

  @override
  void dispose() {
    _userDetailsBloc.close();
    _placeBloc.close();
    _mitraBloc.close();
    _referralBloc.close();
    _cartBloc.close();
    _bottomNavBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppTheme.homeBlue,
    ));

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _userDetailsBloc),
        BlocProvider.value(value: _placeBloc),
        BlocProvider.value(value: _mitraBloc),
        BlocProvider.value(value: _referralBloc),
        BlocProvider.value(value: _cartBloc),
        BlocProvider.value(value: _bottomNavBloc),
        BlocProvider.value(value: _popLockBloc),
      ],
      child: MaterialApp(
        onGenerateRoute: Router.generateRoute,
        navigatorKey: navigatorKey,
        title: 'freshOk',
        home: App(),
      ),
    );
  }
}
