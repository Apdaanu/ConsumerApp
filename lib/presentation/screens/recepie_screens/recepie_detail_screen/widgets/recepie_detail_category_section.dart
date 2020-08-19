import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/presentation/screens/recepie_screens/recepie_detail_screen/recepie_detail_bloc/recepie_detail_bloc.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';

class RecepieDetailCategorySection extends StatelessWidget {
  const RecepieDetailCategorySection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecepieDetailBloc recepieDetailBloc = context.bloc<RecepieDetailBloc>();
    Measure measure = MeasureImpl(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10 + measure.screenHeight * 0.02),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          RecepieDetailCategorySectionItem(
            title: 'Dish Type',
            type: recepieDetailBloc.recepie.categories[0]['name'],
            image: recepieDetailBloc.recepie.categories[0]['image'],
          ),
          RecepieDetailCategorySectionItem(
            title: "Cuisine",
            type: recepieDetailBloc.recepie.cuisines[0]['name'],
            image: recepieDetailBloc.recepie.cuisines[0]['image'],
          ),
        ],
      ),
    );
  }
}

class RecepieDetailCategorySectionItem extends StatelessWidget {
  final String title;
  final String type;
  final String image;

  const RecepieDetailCategorySectionItem({
    Key key,
    @required this.title,
    @required this.type,
    @required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: 80 + measure.width * 0.05,
                height: 80 + measure.width * 0.05,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                    image: Image.network(image).image,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                width: 80 + measure.width * 0.05,
                height: 80 + measure.width * 0.05,
                padding: EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.bottomCenter,
                //*Removed after UI requirement
                // child: RegularText(
                //   text: type,
                //   color: Colors.white,
                //   fontSize: AppTheme.smallTextSize,
                // ),
              )
            ],
          ),
          SizedBox(height: 5),
          RegularText(
            text: title,
            color: AppTheme.black2,
            fontSize: AppTheme.smallTextSize,
          )
        ],
      ),
    );
  }
}
