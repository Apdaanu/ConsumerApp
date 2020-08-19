import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:freshOk/core/constants/routes.dart';
import 'package:freshOk/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

const REFERRAL_CACHE = 'referral';

class DynamicLinkService {
  final SharedPreferences preferences;

  DynamicLinkService(this.preferences);

  Future<void> initDynamicLinks() async {
    print('[sys] : init dynamic link');
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      if (deepLink.path == '/referral') {
        preferences.setString(REFERRAL_CACHE, deepLink.queryParameters['ref']);
      }
    }

    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData data) async {
        final Uri dl = data?.link;
        if (dl != null) {
          if (dl.path == '/referral') {
            preferences.setString(
              REFERRAL_CACHE,
              dl.queryParameters['ref'],
            );
          }
          if (dl.path == '/recipe') {
            navigatorKey.currentState.pushNamed(
              recepieDetailRoute,
              arguments: {'id': dl.queryParameters['ref']},
            );
          }
        }
      },
      onError: (OnLinkErrorException e) async {
        print('[err] : ${e.message}');
      },
    );
  }
}
