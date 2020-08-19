import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/constants/routes.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/core/util/util.dart';
import 'package:freshOk/domain/entities/categories/sub_category.dart';
import 'package:freshOk/injection_container.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/user_details_bloc/user_details_bloc.dart';
import 'package:freshOk/presentation/screens/recepie_screens/recepie_home_screen/recepie_home_card_bloc/recepie_home_card_bloc.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';

class RecepieCategorySectionCard extends StatefulWidget {
  final SubCategory subCategory;

  const RecepieCategorySectionCard({
    Key key,
    @required this.subCategory,
  }) : super(key: key);

  @override
  _RecepieCategorySectionCardState createState() =>
      _RecepieCategorySectionCardState();
}

class _RecepieCategorySectionCardState
    extends State<RecepieCategorySectionCard> {
  RecepieHomeCardBloc _recepieHomeCardBloc;
  UserDetailsBloc userDetailsBloc;

  @override
  void initState() {
    super.initState();
    _recepieHomeCardBloc = sl<RecepieHomeCardBloc>();
    userDetailsBloc = context.bloc<UserDetailsBloc>();
    _recepieHomeCardBloc.add(
      CardBlocInit(
        widget.subCategory,
        userDetailsBloc.userDetails.userId,
      ),
    );
  }

  @override
  void dispose() {
    _recepieHomeCardBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            recepieDetailRoute,
            arguments: {
              'id': widget.subCategory.value,
              'backFxn': (recepieId) {
                _recepieHomeCardBloc.add(UpdateCardLikeRecepie());
              }
            },
          );
        },
        child: Container(
          width: 150 + measure.width * 0.25,
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
          child: BlocBuilder(
            cubit: _recepieHomeCardBloc,
            builder: (context, state) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BlocProvider.value(
                  value: _recepieHomeCardBloc,
                  child: RecepieCategoryCardImageSection(
                    subCategory: widget.subCategory,
                  ),
                ),
                RecepieCategoryCardDetailSection(
                    subCategory: widget.subCategory),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RecepieCategoryCardImageSection extends StatelessWidget {
  final SubCategory subCategory;

  const RecepieCategoryCardImageSection({
    Key key,
    @required this.subCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    RecepieHomeCardBloc recepieHomeCardBloc =
        context.bloc<RecepieHomeCardBloc>();

    return Stack(
      children: <Widget>[
        Container(
          height: (150 + measure.width * 0.25) * 0.75,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.network(subCategory.image).image,
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
                    recepieHomeCardBloc.add(
                      CardLikeRecepie(),
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        recepieHomeCardBloc.isLiked
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: recepieHomeCardBloc.isLiked
                            ? AppTheme.cartRed
                            : Colors.white,
                        size: 20 * measure.fontRatio,
                      ),
                      SizedBox(width: 5),
                      RegularText(
                        text: subCategory.likes.length.toString(),
                        color: Colors.white,
                        fontSize: AppTheme.smallTextSize,
                      ),
                    ],
                  ),
                ),
                RegularText(
                  text: Util.recepieTimeFormatter(subCategory.recepieTime),
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

class RecepieCategoryCardDetailSection extends StatelessWidget {
  final SubCategory subCategory;

  const RecepieCategoryCardDetailSection({
    Key key,
    @required this.subCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 5 + measure.screenHeight * 0.005),
          RegularText(
            text: subCategory.title,
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
                    image: Image.network(subCategory.userDetails.profilePhoto)
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
                    text: subCategory.userDetails.name,
                    color: AppTheme.black3,
                    fontSize: AppTheme.smallTextSize,
                    fontWeight: FontWeight.bold,
                  ),
                  RegularText(
                    text: "Chef",
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
    );
  }
}
