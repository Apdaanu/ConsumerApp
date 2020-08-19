import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/core/util/util.dart';

import '../../../../../core/constants/measure.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../widgets/regular_text.dart';
import '../recepie_detail_bloc/recepie_detail_bloc.dart';

class RecepieDetailTimingSection extends StatelessWidget {
  const RecepieDetailTimingSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecepieDetailBloc recepieDetailBloc = context.bloc<RecepieDetailBloc>();
    Measure measure = MeasureImpl(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10 + measure.width * 0.01),
      child: Column(
        children: <Widget>[
          SizedBox(height: 10 + measure.screenHeight * 0.01),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 15 + measure.width * 0.02,
              vertical: 5 + measure.screenHeight * 0.01,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: RegularText(
              text: '“' + recepieDetailBloc.recepie.description + '”',
              color: AppTheme.black3,
              fontSize: AppTheme.regularTextSize,
              overflow: false,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10 + measure.screenHeight * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              recepieDetailBloc.recepie.preparationTime != null &&
                      recepieDetailBloc.recepie.preparationTime != 0
                  ? RecepieDetailTimingSectionTimeItems(
                      time: recepieDetailBloc.recepie.preparationTime,
                      title: "PREPARATION",
                    )
                  : Container(),
              recepieDetailBloc.recepie.cookingTime != null &&
                      recepieDetailBloc.recepie.cookingTime != 0
                  ? RecepieDetailTimingSectionTimeItems(
                      time: recepieDetailBloc.recepie.cookingTime,
                      title: "COOKING",
                    )
                  : Container(),
              RecepieDetailTimingSectionTimeItems(
                time: recepieDetailBloc.recepie.cookingTime +
                    recepieDetailBloc.recepie.preparationTime,
                title: "TOTAL",
              ),
            ],
          ),
          SizedBox(height: 10 + measure.screenHeight * 0.01),
          SizedBox(height: 10 + measure.screenHeight * 0.01),
        ],
      ),
    );
  }
}

class RecepieDetailTimingSectionTimeItems extends StatelessWidget {
  final String title;
  final int time;
  const RecepieDetailTimingSectionTimeItems({
    Key key,
    @required this.title,
    @required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: measure.width * 0.22,
            height: measure.width * 0.22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(measure.width * 0.2),
              border: Border.all(
                width: 1,
                color: Color(0xff7b7b7b),
              ),
            ),
            child: RegularText(
              text: Util.recepieTimeFormatter(time),
              color: AppTheme.black5,
              fontSize: AppTheme.regularTextSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          RegularText(
            text: title,
            color: AppTheme.black3,
            fontSize: AppTheme.regularTextSize,
            fontWeight: FontWeight.bold,
          )
        ],
      ),
    );
  }
}
