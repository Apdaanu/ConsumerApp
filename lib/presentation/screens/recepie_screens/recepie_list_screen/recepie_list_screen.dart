import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/measure.dart';
import '../../../../core/theme/theme.dart';
import '../../../../injection_container.dart';
import '../../../widgets/card_shimmer.dart';
import '../../../widgets/display_screen.dart';
import '../../../widgets/regular_text.dart';
import '../../../widgets/top_bar_with_search.dart';
import '../../bottom_nav_holder/blocs/user_details_bloc/user_details_bloc.dart';
import 'bloc/recepie_list_bloc.dart';
import 'widgets/recepie_list_card.dart';

class RecepieListScreen extends StatefulWidget {
  final String categoryId;
  final String sectionId;
  final String title;
  final String whichPage;
  final String recepieType;

  const RecepieListScreen({
    Key key,
    @required this.categoryId,
    @required this.sectionId,
    @required this.title,
    @required this.whichPage,
    @required this.recepieType,
  }) : super(key: key);

  @override
  _RecepieListScreenState createState() => _RecepieListScreenState();
}

class _RecepieListScreenState extends State<RecepieListScreen> {
  RecepieListBloc _recepieListBloc;
  UserDetailsBloc _userDetailsBloc;

  @override
  void initState() {
    super.initState();
    _userDetailsBloc = context.bloc<UserDetailsBloc>();
    _recepieListBloc = sl<RecepieListBloc>();
    _recepieListBloc.add(
      RecepieListInit(
        categoryId: widget.categoryId,
        sectioId: widget.sectionId,
        type: widget.recepieType,
        userId: _userDetailsBloc.userDetails.userId,
        whichPage: widget.whichPage,
      ),
    );
  }

  @override
  void dispose() {
    _recepieListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return DisplayScreen(
      topBar: Container(
        height: measure.topBarHeight,
        child: CustomTopBarWithSearch(
          title: widget.title,
          onSearch: (search) {
            _recepieListBloc.add(RecepieSearchEvent(search));
          },
        ),
      ),
      body: BlocBuilder(
        cubit: _recepieListBloc,
        builder: (context, state) {
          if (state is RecepieListLoaded) {
            return Container(
              height: measure.bodyHeight,
              color: Colors.white,
              child: BlocProvider.value(
                value: _recepieListBloc,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: _renderRecepies(state.recepies),
                ),
              ),
            );
          }
          return Container(
            height: measure.bodyHeight,
            child: ListView(
              children: List.generate(
                9,
                (index) => CardShimmer(lag: index * 10),
              ),
            ),
          );
        },
      ),
      failure: false,
      failureCode: 0,
    );
  }

  List<Widget> _renderRecepies(List recepies) {
    List<Widget> list = List<Widget>();
    for (int i = 0; i < recepies.length; i += 2) {
      if (i + 1 == recepies.length) {
        list.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RecepieListCard(recepie: recepies[i]),
            ],
          ),
        );
        continue;
      }
      list.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RecepieListCard(recepie: recepies[i]),
            RecepieListCard(recepie: recepies[i + 1]),
          ],
        ),
      );
    }
    if (list.length == 0) {
      list.add(
        RegularText(
          text: "Oops, no recepies!",
          color: AppTheme.black3,
          fontSize: AppTheme.regularTextSize,
        ),
      );
    }
    return list;
  }
}
