import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/bottom_nav/bottom_nav_bloc.dart';

import '../../../core/constants/measure.dart';
import '../../../core/theme/theme.dart';
import '../../../injection_container.dart';
import '../../widgets/card_shimmer.dart';
import '../../widgets/display_screen.dart';
import '../../widgets/regular_text.dart';
import '../../widgets/top_bar_with_search.dart';
import '../bottom_nav_holder/blocs/cart_bloc/cart_bloc.dart';
import '../bottom_nav_holder/blocs/user_details_bloc/user_details_bloc.dart';
import 'bloc/product_list_bloc.dart';
import 'widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  final String sectionId;
  final String categoryId;
  final String title;
  final bool fromSearch;

  const ProductListScreen({
    Key key,
    @required this.sectionId,
    @required this.categoryId,
    @required this.title,
    this.fromSearch,
  }) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  ProductListBloc _productListBloc;
  CartBloc _cartBloc;
  UserDetailsBloc _userDetailsBloc;
  BottomNavBloc _bottomNavBloc;

  @override
  void initState() {
    super.initState();
    _productListBloc = sl<ProductListBloc>();
    _userDetailsBloc = context.bloc<UserDetailsBloc>();
    _cartBloc = context.bloc<CartBloc>();
    _bottomNavBloc = context.bloc<BottomNavBloc>();

    _productListBloc.add(
      ProductListInit(
        cateroryId: widget.categoryId,
        sectionId: widget.sectionId,
        type: 'productCategory',
        userId: _userDetailsBloc.userDetails.userId,
        cart: _cartBloc.cart,
        fromSearch: widget.fromSearch,
      ),
    );
  }

  @override
  void dispose() {
    _productListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return DisplayScreen(
      topBar: Container(
        color: Colors.white,
        child: CustomTopBarWithSearch(
          title: widget.title,
          onSearch: (value) {
            _productListBloc.add(ProductSearchEvent(value));
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: measure.bodyHeight,
            child: SingleChildScrollView(
              child: BlocBuilder(
                cubit: _productListBloc,
                builder: (context, state) {
                  if (state is ProductListLoaded) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5 + measure.width * 0.01,
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10 + measure.screenHeight * 0.01),
                          Column(
                            children: _renderProducts(state.products),
                          ),
                          SizedBox(height: 10 + measure.screenHeight * 0.01),
                        ],
                      ),
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Column(
                      children: List.generate(
                        9,
                        (index) => CardShimmer(lag: index * 10),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: BlocBuilder(
              cubit: _cartBloc,
              builder: (context, state) => _cartBloc.cart.cart.length == 0
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _bottomNavBloc.add(2);
                      },
                      child: Container(
                        height: measure.topBarHeight,
                        width: measure.width,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10 + measure.width * 0.02),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                blurRadius: 1,
                                color: Color(0x29000000),
                                offset: Offset(0, -1),
                              ),
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.shopping_cart,
                                  color: AppTheme.primaryColor,
                                  size: 18 * measure.fontRatio,
                                ),
                                SizedBox(width: 5),
                                RegularText(
                                  text: 'GOTO CART',
                                  color: AppTheme.primaryColor,
                                  fontSize: AppTheme.regularTextSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            RegularText(
                              text: _cartBloc.cart.cart.length.toString() +
                                  ' Items',
                              color: AppTheme.primaryColor,
                              fontSize: AppTheme.regularTextSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
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

  List<Widget> _renderProducts(List products) {
    Measure measure = MeasureImpl(context);
    List<Widget> list = List<Widget>();
    products.forEach((element) {
      list.add(ProductCard(product: element));
    });
    list.add(SizedBox(height: measure.topBarHeight));
    return list;
  }
}
