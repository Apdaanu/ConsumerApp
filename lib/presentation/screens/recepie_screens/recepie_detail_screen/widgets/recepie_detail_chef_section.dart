import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/presentation/screens/recepie_screens/recepie_detail_screen/recepie_detail_bloc/recepie_detail_bloc.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';

class RecepieDetailChefSection extends StatelessWidget {
  RecepieDetailChefSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecepieDetailBloc recepieDetailBloc = context.bloc<RecepieDetailBloc>();
    Measure measure = MeasureImpl(context);
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 5 + measure.screenHeight * 0.01,
        horizontal: 10 + measure.width * 0.01,
      ),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 50 + measure.width * 0.04,
            width: 50 + measure.width * 0.04,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(
                image: Image.network(
                  recepieDetailBloc.recepie.userDetails.profilePhoto,
                ).image,
              ),
            ),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RegularText(
                text: recepieDetailBloc.recepie.userDetails.name,
                color: AppTheme.black3,
                fontSize: AppTheme.regularTextSize,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 5),
              Row(
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 3,
                    decoration: BoxDecoration(
                      gradient: AppTheme.gradient,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: 2),
                  Container(
                    width: 10,
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
