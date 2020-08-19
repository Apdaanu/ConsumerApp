import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/presentation/screens/select_city_area_screen/select_place_bloc/select_place_bloc.dart';

class SelectCityAreaSearchBar extends StatelessWidget {
  const SelectCityAreaSearchBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SelectPlaceBloc selectPlaceBloc = context.bloc<SelectPlaceBloc>();
    Measure measure = MeasureImpl(context);
    return Container(
      padding: EdgeInsets.only(
        bottom: 25,
        top: 10,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 3,
            offset: Offset(0, 1),
            color: Color(0x0a000000),
          ),
        ],
      ),
      child: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Color(0xffeceff1),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.search,
              color: AppTheme.black5,
              size: 20,
            ),
            SizedBox(width: 5),
            SizedBox(
              width: measure.width - 89,
              child: TextField(
                onChanged: (value) {
                  selectPlaceBloc.add(SelectPlaceSearch(value));
                },
                cursorColor: AppTheme.black3,
                cursorWidth: 2,
                maxLines: 1,
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: -13),
                  hintText: "Search cities...",
                  hintStyle: TextStyle(
                    fontFamily: "Open Sans",
                    fontSize: AppTheme.smallTextSize * measure.fontRatio,
                    color: AppTheme.black5,
                  ),
                ),
                style: TextStyle(
                  fontFamily: "Open Sans",
                  fontSize: AppTheme.smallTextSize * measure.fontRatio,
                  color: AppTheme.black3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
