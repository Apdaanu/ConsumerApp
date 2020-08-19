import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/measure.dart';
import '../../../../core/theme/theme.dart';
import '../../../../injection_container.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/display_screen.dart';
import '../../../widgets/regular_text.dart';
import 'create_recepie_bloc/create_recepie_bloc.dart';
import 'widgets/create_recepie_form/create_recepie_form.dart';
import 'widgets/create_recepie_top_bar.dart';

class CreateRecepieHomeScreen extends StatefulWidget {
  @override
  _CreateRecepieHomeScreenState createState() =>
      _CreateRecepieHomeScreenState();
}

class _CreateRecepieHomeScreenState extends State<CreateRecepieHomeScreen> {
  CreateRecepieBloc _createRecepieBloc;

  @override
  void initState() {
    super.initState();
    _createRecepieBloc = sl<CreateRecepieBloc>();
  }

  @override
  void dispose() {
    _createRecepieBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return DisplayScreen(
      topBar: BlocProvider.value(
        value: _createRecepieBloc,
        child: CreateRecepieTopBar(),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Color(0xfff5f5f5),
            margin: EdgeInsets.only(top: 15),
            height: measure.bodyHeight - 15,
            child: BlocProvider.value(
              value: _createRecepieBloc,
              child: CreateRecepieForm(),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: measure.width,
              height: measure.topBarHeight + 15,
              padding: EdgeInsets.symmetric(horizontal: measure.width * 0.05),
              color: Colors.white,
              child: BlocBuilder(
                cubit: _createRecepieBloc,
                builder: (context, state) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomButton(
                      height: 45,
                      width: measure.width * 0.4,
                      onTap: () {
                        _createRecepieBloc.add(CreateRecepieBack());
                      },
                      color: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: AppTheme.black5,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.arrow_back,
                              color: AppTheme.black5,
                              size: 22 * measure.fontRatio,
                            ),
                            SizedBox(width: 10),
                            RegularText(
                              text: "Back",
                              color: AppTheme.black5,
                              fontSize: AppTheme.headingTextSize,
                            ),
                          ],
                        ),
                      ),
                    ),
                    CustomButton(
                      height: 45,
                      width: measure.width * 0.4,
                      onTap: () {
                        _createRecepieBloc.add(CreateRecepieNext());
                      },
                      color: AppTheme.primaryColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RegularText(
                            text: "Next",
                            color: Colors.white,
                            fontSize: AppTheme.headingTextSize,
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 22 * measure.fontRatio,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      failure: false,
      failureCode: 0,
    );
  }
}
