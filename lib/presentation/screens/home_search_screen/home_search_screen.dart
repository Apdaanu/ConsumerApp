import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/routes.dart';
import '../../../core/constants/measure.dart';
import '../../../core/theme/theme.dart';
import '../../../domain/entities/categories/search_response.dart';
import '../../../injection_container.dart';
import 'home_search_bloc/home_search_bloc.dart';
import '../../widgets/card_shimmer.dart';
import '../../widgets/display_screen.dart';
import '../../widgets/regular_text.dart';
import '../../widgets/text_field_underline.dart';

class HomeSearchScreen extends StatefulWidget {
  final String type;

  const HomeSearchScreen({
    Key key,
    this.type,
  }) : super(key: key);

  @override
  _HomeSearchScreenState createState() => _HomeSearchScreenState();
}

class _HomeSearchScreenState extends State<HomeSearchScreen> {
  HomeSearchBloc _homeSearchBloc;

  @override
  void initState() {
    super.initState();
    _homeSearchBloc = sl<HomeSearchBloc>();
    _homeSearchBloc.add(HomeSearchInit(widget.type));
  }

  @override
  void dispose() {
    _homeSearchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return DisplayScreen(
      body: Container(
        height: measure.screenHeight,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    blurRadius: 1,
                    offset: Offset(0, 1),
                    color: Color(0x29000000),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  CustomTextFieldUnderline(
                    onChanged: (value) {
                      _homeSearchBloc.add(SearchProductsEvent(value));
                    },
                    onSubmit: (value) {
                      _homeSearchBloc.add(SearchProductsEvent(value));
                    },
                    hintText: 'Search fruits, vegetables, recepies ...',
                    padding: EdgeInsets.only(
                      left: 25 + measure.width * 0.05,
                      right: 25 + measure.width * 0.05,
                    ),
                    maxLines: 1,
                    fontSize: AppTheme.regularTextSize,
                    autofocus: true,
                  ),
                  Positioned(
                    right: 5 + measure.width * 0.01,
                    child: BlocBuilder(
                      cubit: _homeSearchBloc,
                      builder: (context, state) {
                        if (state is HomeSearchLoading) {
                          return SizedBox(
                            height: 12,
                            width: 12,
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryColor),
                              strokeWidth: 2,
                            ),
                          );
                        }
                        return Icon(
                          Icons.search,
                          color: AppTheme.black7,
                          size: 18 * measure.fontRatio,
                        );
                      },
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(5 + measure.width * 0.01),
                          child: Icon(
                            Icons.keyboard_backspace,
                            color: AppTheme.black7,
                            size: 18 * measure.fontRatio,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: measure.screenHeight - 50,
              width: measure.width,
              child: SingleChildScrollView(
                child: BlocBuilder(
                  cubit: _homeSearchBloc,
                  builder: (context, state) {
                    if (state is HomeSearchLoading) {
                      return Column(
                        children: List.generate(
                          9,
                          (index) => CardShimmer(lag: index * 10),
                        ),
                      );
                    }
                    if (state is HomeSearchLoaded) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _homeSearchBloc.searchRes,
                      );
                    }
                    return Text('Begin your search');
                  },
                ),
              ),
            )
          ],
        ),
      ),
      failure: false,
      failureCode: 0,
    );
  }
}

class SearchResults extends StatelessWidget {
  final SearchResponse searchResponse;
  final SearchCategory category;

  const SearchResults({
    Key key,
    this.category,
    this.searchResponse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return GestureDetector(
      onTap: () {
        if (searchResponse.searchItemType == 'recipe') {
          Navigator.of(context).pushNamed(
            recepieDetailRoute,
            arguments: {
              'id': searchResponse.id,
            },
          );
        } else {
          Navigator.pushNamed(
            context,
            productListRoute,
            arguments: {
              'categoryId': category.id,
              'sectionId': '',
              'title': category.name,
              'fromSearch': true,
            },
          );
        }
      },
      child: Container(
        width: measure.width,
        padding: EdgeInsets.symmetric(
          horizontal: 10 + measure.width * 0.02,
          vertical: 10 + measure.screenHeight * 0.01,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.3, color: Color(0xff707070)),
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                  image: Image.network(searchResponse.image).image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RegularText(
                  text: searchResponse.name,
                  color: AppTheme.black2,
                  fontSize: AppTheme.regularTextSize,
                ),
                RegularText(
                  text: 'in ' + category.name,
                  color: AppTheme.black7,
                  fontSize: AppTheme.smallTextSize,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
