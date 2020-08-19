import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/recepie_home_bloc/recepie_home_bloc.dart';
import 'package:freshOk/presentation/screens/home_screen/widgets/home_screen_shimmer.dart';
import 'package:freshOk/presentation/widgets/loader.dart';

import '../../home_screen/widgets/category_section/category_section.dart';
import '../../home_screen/widgets/category_section_type_2/category_section_type_2.dart';
import 'widgets/recepie_category_section/recepie_category_section.dart';
import 'widgets/recepie_top_bar.dart';

const String INGRIDIENT_TYPE = 'ingredient';
const String CUISINE_TYPE = 'cuisine';
const String CATEGORY_TYPE = 'category';
const String RECEPIE_TYPE = 'recipe';

class RecepieHomeScreen extends StatelessWidget {
  const RecepieHomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecepieHomeBloc recepieHomeBloc = context.bloc<RecepieHomeBloc>();
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          RecepieTopBar(),
          BlocBuilder(
            cubit: recepieHomeBloc,
            builder: (context, state) {
              if (state is RecepieHomeLoaded) {
                return Column(
                  children: _renderSections(recepieHomeBloc.sections),
                );
              }
              return HomeScreenShimmer();
            },
          )
        ],
      ),
    );
  }

  List<Widget> _renderSections(List sections) {
    List<Widget> list = List<Widget>();

    sections.forEach((element) {
      if (element.type == RECEPIE_TYPE) {
        list.add(
          RecepieCategorySection(category: element),
        );
      } else {
        list.add(
          CategorySection(
            category: element,
            whichPage: 'recepie',
          ),
        );
      }
    });

    return list;
  }
}
