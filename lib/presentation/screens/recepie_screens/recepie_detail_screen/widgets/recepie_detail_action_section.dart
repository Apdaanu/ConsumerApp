import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share_me/flutter_share_me.dart';

import '../../../../../core/constants/measure.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../widgets/regular_text.dart';
import '../../../bottom_nav_holder/blocs/user_details_bloc/user_details_bloc.dart';
import '../recepie_detail_bloc/recepie_detail_bloc.dart';

const RECEPIE_SHARE_MSG = 'Hey, checkout this cool recipe!!';

class RecepieDetailActionSection extends StatelessWidget {
  final backFxn;

  const RecepieDetailActionSection({
    Key key,
    this.backFxn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecepieDetailBloc recepieDetailBloc = context.bloc<RecepieDetailBloc>();
    Measure measure = MeasureImpl(context);

    return Container(
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () {
              recepieDetailBloc.add(RecepieDetailLikeEvent());

              if (backFxn != null) {
                backFxn(recepieDetailBloc.recepie.id);
              }
            },
            icon: Icon(
              recepieDetailBloc.isLiked
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: recepieDetailBloc.isLiked
                  ? AppTheme.cartRed
                  : AppTheme.black3,
              size: 22 * measure.fontRatio,
            ),
          ),
          RegularText(
            text: recepieDetailBloc.recepie.likes.length.toString(),
            color: AppTheme.black3,
            fontSize: AppTheme.regularTextSize,
          ),
          Expanded(child: Container()),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _shareLink(recepieDetailBloc.recepie.id, 0);
                },
                child: Image.asset(
                  "assets/images/wa-logo.png",
                  height: 22 * measure.fontRatio,
                ),
              ),
              IconButton(
                onPressed: () {
                  _shareLink(recepieDetailBloc.recepie.id, 1);
                },
                icon: Icon(
                  Icons.share,
                  color: AppTheme.black3,
                  size: 22 * measure.fontRatio,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void _shareLink(String id, int to) async {
    final ShortDynamicLink link = await _createDynamicLink(id);
    final String message = link.shortUrl.toString() + '\n' + RECEPIE_SHARE_MSG;
    if (to == 0)
      FlutterShareMe().shareToWhatsApp(msg: message);
    else if (to == 1) FlutterShareMe().shareToSystem(msg: message);
  }

  Future<ShortDynamicLink> _createDynamicLink(String id) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://freshok.page.link',
      link: Uri.parse('https://freshok.in/recipe?ref=$id'),
      androidParameters: AndroidParameters(
        packageName: 'com.freshhaat.consumer',
        minimumVersion: 0,
      ),
    );

    final ShortDynamicLink dynamicLink = await parameters.buildShortLink();
    return dynamicLink;
  }
}
