import 'package:flutter/material.dart';

import '../../core/constants/routes.dart';
import '../app.dart';
import '../screens/about_screen/about_screen.dart';
import '../screens/bottom_nav_holder/bottom_nav_holder.dart';
import '../screens/customer_support/customer_support_chat/customer_support_chat_screen.dart';
import '../screens/customer_support/customer_support_home/customer_support_home_screen.dart';
import '../screens/home_search_screen/home_search_screen.dart';
import '../screens/mitra_screens/select_mitra_screen/select_mitra_screen.dart';
import '../screens/order_screens/order_details/order_details_screen.dart';
import '../screens/order_screens/order_placed/order_placed_screen.dart';
import '../screens/otp_screen/otp_screen.dart';
import '../screens/phone_screen/phone_screen.dart';
import '../screens/product_list_screen/product_list_screen.dart';
import '../screens/profile_screens/edit_profile_screen/edit_profile_screen.dart';
import '../screens/profile_screens/profile_screen/profile_screen.dart';
import '../screens/recepie_screens/create_recepie_screen/create_recepie_home_screen.dart';
import '../screens/recepie_screens/recepie_detail_screen/recepie_detail_screen.dart';
import '../screens/recepie_screens/recepie_list_screen/recepie_list_screen.dart';
import '../screens/referral_screens/referral_detail_screen/referral_detail_screen.dart';
import '../screens/referral_screens/referral_home_screen/referral_home_screen.dart';
import '../screens/registration_screen.dart/registration_screen.dart';
import '../screens/select_city_area_screen/select_city_area.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case rootRoute:
        return MaterialPageRoute(builder: (_) => App());

      case phoneRoute:
        return MaterialPageRoute(
            builder: (_) => PhoneScreen(key: Key("phoneScreen")));

      case otpRoute:
        final data = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => OtpScreen(
            key: Key("otpScreen"),
            mob: data,
          ),
        );

      case registerRoute:
        return MaterialPageRoute(builder: (_) => RegistrationScreen());

      case homeRoute:
        final data = settings.arguments as int;
        return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) => BottomNavHolder(page: data),
        );

      case orderDetailsRoute:
        final data = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => OrderDetailsScreen(
            orderId: data,
          ),
        );

      case orderPlacedRoute:
        final data = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => OrderPlacedScreen(orderId: data),
        );

      case productListRoute:
        final data = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => ProductListScreen(
            categoryId: data['categoryId'],
            sectionId: data['sectionId'],
            title: data['title'],
            fromSearch: data['fromSearch'],
          ),
        );

      case referralHomeRoute:
        return MaterialPageRoute(builder: (_) => ReferralHomeScreen());

      case referralDetailRoute:
        return MaterialPageRoute(builder: (_) => ReferralDetailsScreen());

      case recepieListRoute:
        final data = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => RecepieListScreen(
            categoryId: data['categoryId'],
            sectionId: data['sectionId'],
            title: data['title'],
            whichPage: data['whichPage'],
            recepieType: data['recepieType'],
          ),
        );

      case recepieDetailRoute:
        final data = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => RecepieDetailScreen(
            recepieId: data['id'],
            backFxn: data['backFxn'],
          ),
        );

      case createRecepieRoute:
        return MaterialPageRoute(builder: (_) => CreateRecepieHomeScreen());

      case selectCityAreaRoute:
        final data = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => SelectCityAreaScreen(
            title: data['title'],
            ddFxn: data['ddFxn'],
            actionName: data['actionName'],
            actionFxn: data['actionFxn'],
            list: data['list'],
            noBack: data['noBack'],
            loading: data['loading'],
          ),
        );

      case selectMitraRoute:
        return MaterialPageRoute(builder: (_) => SelectMitraScreen());

      case editProfileRoute:
        return MaterialPageRoute(builder: (_) => EditProfileScreen());

      case profileScreenRoute:
        return MaterialPageRoute(builder: (_) => ProfileScreen());

      case customerSupportRoute:
        return MaterialPageRoute(builder: (_) => CustomerSupportHomeScreen());

      case customerChatRoute:
        return MaterialPageRoute(builder: (_) => CustomerSupportChatScreen());

      case aboutRoute:
        return MaterialPageRoute(builder: (_) => AboutScreen());

      case homeSearchRoute:
        final data = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => HomeSearchScreen(type: data));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
