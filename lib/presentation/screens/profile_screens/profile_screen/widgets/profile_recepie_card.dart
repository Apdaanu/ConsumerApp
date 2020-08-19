import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/core/util/util.dart';

import '../../../../../core/constants/measure.dart';
import '../../../../../core/constants/routes.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../../domain/entities/categories/recepie.dart';
import '../../../../widgets/regular_text.dart';
import '../../../bottom_nav_holder/blocs/user_details_bloc/user_details_bloc.dart';
import '../profile_recepie_bloc/profile_recepie_bloc.dart';

class ProfileRecepieCard extends StatelessWidget {
  final Recepie recepie;

  const ProfileRecepieCard({
    Key key,
    @required this.recepie,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ProfileRecepieBloc profileRecepieBloc = context.bloc<ProfileRecepieBloc>();
    Measure measure = MeasureImpl(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          recepieDetailRoute,
          arguments: {
            'id': recepie.id,
            'backFxn': (recepieId) {
              profileRecepieBloc.add(
                ProfileRecepieLikeAction(recepie.id),
              );
            }
          },
        );
      },
      child: Container(
        width: measure.width * 0.45,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 3,
              offset: Offset(0, 1),
              color: Color(0x29000000),
            )
          ],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                ProfileRecepieCardImageSection(recepie: recepie),
                ProfileRecepieCardInfoSection(recepie: recepie),
              ],
            ),
            true == false
                ? Positioned(
                    top: 10,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          RegularText(
                            text: "REVIEW",
                            color: AppTheme.black2,
                            fontSize: AppTheme.extraSmallTextSize,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(width: 5),
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: Color(0xfff7be12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class ProfileRecepieCardImageSection extends StatelessWidget {
  final Recepie recepie;

  const ProfileRecepieCardImageSection({Key key, this.recepie})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProfileRecepieBloc profileRecepieBloc = context.bloc<ProfileRecepieBloc>();
    UserDetailsBloc userDetailsBloc = context.bloc<UserDetailsBloc>();
    Measure measure = MeasureImpl(context);
    final bool reviewRes = false;

    var isLiked =
        recepie.likes.indexOf(userDetailsBloc.userDetails.userId) == -1
            ? false
            : true;

    return Stack(
      children: <Widget>[
        Container(
          height: (measure.width * 0.45),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.network(recepie.images[0]).image,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: 150 + measure.width * 0.25,
            padding: EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 5,
            ),
            decoration: BoxDecoration(
              color: Color(0x99000000),
            ),
            child: GestureDetector(
              onTap: () {
                profileRecepieBloc.add(ProfileRecepieLike(recepie.id));
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? AppTheme.cartRed : Colors.white,
                    size: 16 * measure.fontRatio,
                  ),
                  SizedBox(width: 5),
                  RegularText(
                    text: recepie.likes.length.toString(),
                    color: Colors.white,
                    fontSize: AppTheme.smallTextSize,
                  ),
                ],
              ),
            ),
          ),
        ),
        recepie.cookingTime != null
            ? Positioned(
                bottom: 7,
                right: 10,
                child: RegularText(
                  text: Util.recepieTimeFormatter(
                      recepie.cookingTime + recepie.preparationTime),
                  color: Colors.white,
                  fontSize: AppTheme.extraSmallTextSize,
                ),
              )
            : Container(),
      ],
    );
  }
}

class ProfileRecepieCardInfoSection extends StatelessWidget {
  final Recepie recepie;

  const ProfileRecepieCardInfoSection({
    Key key,
    this.recepie,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RegularText(
                text: recepie.title,
                color: AppTheme.black2,
                fontSize: AppTheme.smallTextSize,
              ),
              false == true
                  ? Icon(Icons.edit, color: AppTheme.black3, size: 15)
                  : Container(),
            ],
          ),
          SizedBox(height: 10),
          RegularText(
            text: recepie.description,
            color: AppTheme.black7,
            fontSize: AppTheme.smallTextSize,
            maxLines: 3,
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
