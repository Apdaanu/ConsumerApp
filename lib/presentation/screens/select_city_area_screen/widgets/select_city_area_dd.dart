import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/presentation/screens/select_city_area_screen/select_place_bloc/select_place_bloc.dart';

import '../../../../core/constants/measure.dart';
import '../../../../core/theme/theme.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/regular_text.dart';

class SelectCityAreaDD extends StatelessWidget {
  final ddFxn;
  final bool loading;

  const SelectCityAreaDD({
    Key key,
    this.ddFxn,
    this.loading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SelectPlaceBloc selectPlaceBloc = context.bloc<SelectPlaceBloc>();
    Measure measure = MeasureImpl(context);
    return Container(
      height: measure.bodyHeight - 95,
      width: measure.width * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 1,
            offset: Offset(0, 0),
            color: Color(0x29000000),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: BlocBuilder(
          cubit: selectPlaceBloc,
          builder: (context, state) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _renderPlaces(selectPlaceBloc.searchRes),
          ),
        ),
      ),
    );
  }

  List<Widget> _renderPlaces(List list) {
    if (loading) {
      return [
        Container(
          child: Text("Loading"),
        )
      ];
    } else {
      List<Widget> widgetList = new List<Widget>();
      list.forEach((element) {
        widgetList.add(
          SelectCityAreaDDItem(
            item: element,
            onTap: ddFxn,
          ),
        );
      });
      return widgetList;
    }
  }
}

class SelectCityAreaDDItem extends StatelessWidget {
  final dynamic item;
  final onTap;

  const SelectCityAreaDDItem({
    Key key,
    this.item,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return CustomButton(
      height: null,
      width: null,
      onTap: () {
        if (onTap != null)
          onTap(item.id);
        else
          print('[err] : No Functionality defined');
      },
      color: Colors.white,
      child: Container(
        width: measure.width,
        padding: EdgeInsets.symmetric(
          horizontal: 10 + measure.width * 0.02,
          vertical: 5 + measure.screenHeight * 0.01,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.2,
              color: Color(0xff707070),
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RegularText(
              text: item.name,
              color: AppTheme.black2,
              fontSize: AppTheme.smallTextSize,
              fontWeight: FontWeight.w500,
            ),
            RegularText(
              text: item.parent ?? '',
              color: AppTheme.black7,
              fontSize: AppTheme.smallTextSize,
            ),
          ],
        ),
      ),
    );
  }
}
