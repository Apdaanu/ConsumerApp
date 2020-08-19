import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/injection_container.dart';
import 'package:freshOk/presentation/screens/select_city_area_screen/select_place_bloc/select_place_bloc.dart';

import '../../../core/constants/measure.dart';
import '../../widgets/display_screen.dart';
import 'widgets/select_city_area_dd.dart';
import 'widgets/select_city_area_search_bar.dart';
import 'widgets/select_city_area_top_bar.dart';

class SelectCityAreaScreen extends StatefulWidget {
  final String title;
  final String actionName;
  final bool noBack;
  final List<dynamic> list;
  final actionFxn;
  final ddFxn;
  final bool loading;
  final backAlt;

  const SelectCityAreaScreen({
    Key key,
    this.actionName,
    this.actionFxn,
    @required this.list,
    @required this.title,
    this.noBack,
    @required this.ddFxn,
    @required this.loading,
    this.backAlt,
  }) : super(key: key);

  @override
  _SelectCityAreaScreenState createState() => _SelectCityAreaScreenState();
}

class _SelectCityAreaScreenState extends State<SelectCityAreaScreen> {
  SelectPlaceBloc _selectPlaceBloc;

  @override
  void initState() {
    super.initState();
    _selectPlaceBloc = sl<SelectPlaceBloc>();

    _selectPlaceBloc.add(SelectPlaceInit(widget.list));
  }

  @override
  void dispose() {
    _selectPlaceBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return DisplayScreen(
      topBar: SelectCityAreaTopBar(
        title: widget.title,
        noBack: widget.noBack,
        actionFxn: widget.actionFxn,
        actionName: widget.actionName,
        backAlt: widget.backAlt,
      ),
      body: Container(
          height: measure.bodyHeight,
          color: Color(0xffeceff1),
          child: BlocProvider.value(
            value: _selectPlaceBloc,
            child: Column(
              children: <Widget>[
                SelectCityAreaSearchBar(),
                SizedBox(height: 20),
                SelectCityAreaDD(
                  ddFxn: widget.ddFxn,
                  loading: widget.loading,
                ),
              ],
            ),
          )),
      failure: false,
      failureCode: 0,
    );
  }
}
