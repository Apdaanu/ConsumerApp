import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/theme.dart';
import '../bottom_nav_holder/blocs/home_section/home_section_bloc.dart';
import 'widgets/category_section/category_section.dart';
import 'widgets/home_screen_shimmer.dart';
import 'widgets/home_search_section/home_search_section.dart';
import 'widgets/home_top_bar/home_top_bar.dart';
import 'widgets/offer_section/offer_section.dart';
import 'widgets/suggested_section/suggested_section.dart';

const String OFFER_TYPE = 'banner';
const String PRODUCT_TYPE = 'productCategory';
const String RECEPIE_TYPE = 'recipeCategory';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeSectionBloc _homeSectionBloc;

  @override
  void initState() {
    _homeSectionBloc = context.bloc<HomeSectionBloc>();

    super.initState();
  }

  List<Widget> _renderSections(List sections) {
    List<Widget> list = List<Widget>();
    sections.forEach((element) {
      if (element.type == OFFER_TYPE) {
        list.add(
          OfferSection(
            category: element,
          ),
        );
      } else if (element.type == PRODUCT_TYPE || element.type == RECEPIE_TYPE) {
        list.add(
          CategorySection(
            category: element,
            whichPage: 'home',
          ),
        );
      }
    });
    list.add(SuggestedSection());
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: AppTheme.homeBlue,
            ),
            child: Column(
              children: <Widget>[
                HomeTopBar(),
                HomeSearchSection(),
              ],
            ),
          ),
          BlocBuilder(
            cubit: _homeSectionBloc,
            builder: (context, state) {
              if (state is HomeSectionLoading) {
                return HomeScreenShimmer();
              }
              if (state is HomeSectionLoaded) {
                return Column(children: _renderSections(state.sections));
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
