import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/core/util/util.dart';
import 'package:freshOk/domain/entities/categories/recepie.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/user_details_bloc/user_details_bloc.dart';
import 'package:freshOk/presentation/screens/recepie_screens/recepie_list_screen/bloc/recepie_list_bloc.dart';

import '../../../../../core/constants/measure.dart';
import '../../../../../core/constants/routes.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../widgets/regular_text.dart';

class RecepieListCard extends StatelessWidget {
  final Recepie recepie;
  const RecepieListCard({
    Key key,
    @required this.recepie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    RecepieListBloc recepieListBloc = context.bloc<RecepieListBloc>();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            recepieDetailRoute,
            arguments: {
              'id': recepie.id,
              'backFxn': (recepieId) {
                recepieListBloc.add(UpdateRecepieLike(recepieId));
              }
            },
          );
        },
        child: Container(
          width: measure.width * 0.45,
          margin: EdgeInsets.symmetric(horizontal: 5 + measure.width * 0.01),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                blurRadius: 3,
                offset: Offset(0, 1),
                color: Color(0x29000000),
              ),
            ],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RecepieListCardImageSection(recepie: recepie),
              RecepieListCardDetailSection(recepie: recepie),
            ],
          ),
        ),
      ),
    );
  }
}

class RecepieListCardImageSection extends StatelessWidget {
  final Recepie recepie;

  const RecepieListCardImageSection({Key key, this.recepie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecepieListBloc recepieListBloc = context.bloc<RecepieListBloc>();
    UserDetailsBloc userDetailsBloc = context.bloc<UserDetailsBloc>();
    Measure measure = MeasureImpl(context);

    var isLiked =
        recepie.likes.indexOf(userDetailsBloc.userDetails.userId) != -1
            ? true
            : false;

    return Stack(
      children: <Widget>[
        Container(
          height: (measure.width * 0.45) * 0.75,
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
            width: measure.width * 0.45,
            padding: EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              color: Color(0x99000000),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    recepieListBloc.add(LikeRecepieEvent(recepie.id));
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? AppTheme.cartRed : Colors.white,
                        size: 20 * measure.fontRatio,
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
                RegularText(
                  text: Util.recepieTimeFormatter(
                    recepie.cookingTime + recepie.preparationTime,
                  ),
                  color: Colors.white,
                  fontSize: AppTheme.extraSmallTextSize,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RecepieListCardDetailSection extends StatelessWidget {
  final Recepie recepie;

  const RecepieListCardDetailSection({Key key, this.recepie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5 + measure.screenHeight * 0.005),
              RegularText(
                text: recepie.title,
                color: AppTheme.black2,
                fontSize: AppTheme.regularTextSize,
              ),
              SizedBox(height: 10 + measure.screenHeight * 0.02),
              Row(
                children: <Widget>[
                  Container(
                    width: 30 + measure.width * 0.01,
                    height: 30 + measure.width * 0.01,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      image: DecorationImage(
                        image: Image.network(recepie.userDetails.profilePhoto)
                            .image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RegularText(
                        text: recepie.userDetails.name,
                        color: AppTheme.black3,
                        fontSize: AppTheme.smallTextSize,
                        fontWeight: FontWeight.bold,
                      ),
                      RegularText(
                        text: "placeholder",
                        color: Colors.transparent,
                        fontSize: AppTheme.smallTextSize,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5 + measure.screenHeight * 0.005),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 50 + measure.width * 0.01,
          child: Container(
            height: 25,
            width: 10,
            color: AppTheme.darkGreen,
          ),
        ),
      ],
    );
  }
}
