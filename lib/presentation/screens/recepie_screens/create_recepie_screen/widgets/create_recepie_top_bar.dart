import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/measure.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../widgets/regular_text.dart';
import '../create_recepie_bloc/create_recepie_bloc.dart';

class CreateRecepieTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CreateRecepieBloc createRecepieBloc = context.bloc<CreateRecepieBloc>();
    Measure measure = MeasureImpl(context);
    return Stack(
      children: <Widget>[
        Container(
          height: measure.topBarHeight + 15,
          padding: EdgeInsets.symmetric(horizontal: 5 + measure.width * 0.01),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                blurRadius: 3,
                offset: Offset(0, 1),
                color: Color(0x29000000),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: AppTheme.black3,
                  size: 22 * measure.fontRatio,
                ),
              ),
              SizedBox(width: 10),
              RegularText(
                text: "Create Recepie",
                color: AppTheme.black2,
                fontSize: AppTheme.headingTextSize,
              ),
              Expanded(child: Container()),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.visibility,
                    color: AppTheme.primaryColor,
                    size: 18 * measure.fontRatio,
                  ),
                  RegularText(
                    text: "Preview",
                    color: AppTheme.primaryColor,
                    fontSize: AppTheme.extraSmallTextSize,
                  )
                ],
              )
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: SizedBox(
            width: measure.width,
            child: BlocBuilder(
              cubit: createRecepieBloc,
              builder: (context, state) => Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  createRecepieBloc.totalSteps,
                  (index) => CreateRecepieProgressSteps(
                    currStep: createRecepieBloc.step,
                    index: index,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CreateRecepieProgressSteps extends StatelessWidget {
  final int index;
  final int currStep;

  const CreateRecepieProgressSteps({
    Key key,
    @required this.index,
    @required this.currStep,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Color color =
        index <= currStep ? AppTheme.darkGreen : Colors.grey[400];

    Measure measure = MeasureImpl(context);
    return Container(
      height: 7,
      width: measure.width / 4 - 2,
      color: color,
    );
  }
}
