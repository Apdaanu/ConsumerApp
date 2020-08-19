import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/presentation/screens/recepie_screens/recepie_detail_screen/widgets/recepie_detail_shimmer.dart';

import '../../../../core/constants/measure.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/util/util.dart';
import '../../../../injection_container.dart';
import '../../../widgets/display_screen.dart';
import '../../../widgets/loader.dart';
import '../../../widgets/regular_text.dart';
import '../../bottom_nav_holder/blocs/bottom_nav/bottom_nav_bloc.dart';
import '../../bottom_nav_holder/blocs/cart_bloc/cart_bloc.dart';
import '../../bottom_nav_holder/blocs/user_details_bloc/user_details_bloc.dart';
import 'recepie_detail_bloc/recepie_detail_bloc.dart';
import 'widgets/recepie_detail_action_section.dart';
import 'widgets/recepie_detail_category_section.dart';
import 'widgets/recepie_detail_chef_section.dart';
import 'widgets/recepie_detail_image_section.dart';
import 'widgets/recepie_detail_ingredients_section.dart';
import 'widgets/recepie_detail_steps_section.dart';
import 'widgets/recepie_detail_timing_section.dart';
import 'widgets/recepie_detail_video_section.dart';

class RecepieDetailScreen extends StatefulWidget {
  final String recepieId;
  final backFxn;

  const RecepieDetailScreen({
    Key key,
    @required this.recepieId,
    @required this.backFxn,
  }) : super(key: key);

  @override
  _RecepieDetailScreenState createState() => _RecepieDetailScreenState();
}

class _RecepieDetailScreenState extends State<RecepieDetailScreen> {
  RecepieDetailBloc _recepieDetailBloc;
  CartBloc _cartBloc;
  UserDetailsBloc _userDetailsBloc;
  BottomNavBloc _bottomNavBloc;

  @override
  void initState() {
    super.initState();
    _recepieDetailBloc = sl<RecepieDetailBloc>();
    _cartBloc = context.bloc<CartBloc>();
    _userDetailsBloc = context.bloc<UserDetailsBloc>();
    _bottomNavBloc = context.bloc<BottomNavBloc>();
    _recepieDetailBloc.add(
      RecepieDetailsInit(
        cart: _cartBloc.cart,
        recepieId: widget.recepieId,
        userId: _userDetailsBloc.userDetails.userId,
      ),
    );
  }

  @override
  void dispose() {
    _recepieDetailBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return DisplayScreen(
      body: Container(
        height: measure.screenHeight,
        width: measure.width,
        color: Color(0xfff5f5f5),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: BlocProvider.value(
                value: _recepieDetailBloc,
                child: BlocBuilder(
                  cubit: _recepieDetailBloc,
                  builder: (context, state) {
                    if (state is RecepieDetailLoaded) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RecepieDetailImageSection(),
                          RecepieDetailActionSection(backFxn: widget.backFxn),
                          RecepieDetailChefSection(),
                          RecepieDetailTimingSection(),
                          RecepieDetailCategorySection(),
                          RecepieDetailVideoSection(),
                          RecepieDetailIngredientsSection(),
                          SizedBox(height: 10 + measure.screenHeight * 0.02),
                          RecepieDetailStepsSection(),
                          SizedBox(height: 5 + measure.screenHeight * 0.01),
                          SizedBox(height: 5 + measure.screenHeight * 0.01),
                          SizedBox(height: measure.topBarHeight),
                        ],
                      );
                    }
                    return RecepieDetailShimmer();
                  },
                ),
              ),
            ),
            BlocBuilder(
              cubit: _recepieDetailBloc,
              builder: (context, state) {
                if (state is RecepieDetailLoaded) {
                  return Positioned(
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () {
                        if (_calculateTotalRecepieCost(
                                _recepieDetailBloc.recepie.ingredients) >
                            0) {
                          _bottomNavBloc.add(2);
                          Navigator.of(context).popUntil(
                            ModalRoute.withName(homeRoute),
                          );
                        }
                      },
                      child: Container(
                        width: measure.width,
                        height: measure.topBarHeight,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10 + measure.width * 0.02),
                        decoration: BoxDecoration(
                          color: AppTheme.recepiePlaceOrderOrange,
                          // borderRadius: BorderRadius.only(
                          //   topLeft: Radius.circular(4),
                          //   topRight: Radius.circular(4),
                          // ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.shopping_cart,
                              color: AppTheme.black3,
                              size: 18 * measure.fontRatio,
                            ),
                            SizedBox(width: 10),
                            RegularText(
                              text: "PLACE ORDER",
                              color: AppTheme.black2,
                              fontSize: AppTheme.regularTextSize,
                              fontWeight: FontWeight.w500,
                            ),
                            Expanded(child: Container()),
                            RegularText(
                              text: _calculateCartItems().toString() + " Items",
                              color: AppTheme.black2,
                              fontSize: AppTheme.regularTextSize,
                            ),
                            // SizedBox(width: 5),
                            // RegularText(
                            //   text: "|",
                            //   color: AppTheme.black2,
                            //   fontSize: AppTheme.regularTextSize,
                            // ),
                            // SizedBox(width: 5),
                            // RegularText(
                            //   text: "${AppTheme.currencySymbol}" +
                            //       Util.removeDecimalZeroFormat(
                            //         _calculateTotalRecepieCost(
                            //           _recepieDetailBloc.recepie.ingredients,
                            //         ),
                            //       ),
                            //   color: AppTheme.black2,
                            //   fontSize: AppTheme.regularTextSize,
                            //   fontWeight: FontWeight.w500,
                            // ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
      failure: false,
      failureCode: 0,
    );
  }

  double _calculateTotalRecepieCost(List ingridients) {
    double total = 0;
    ingridients.forEach((element) {
      total += element.discountedPrice * element.quantity;
    });
    return total;
  }

  int _calculateCartItems() {
    int count = 0;
    _cartBloc.cart.cart.forEach((key, value) {
      _recepieDetailBloc.recepie.ingredients.forEach((element) {
        if (element.productId == key) {
          count++;
        }
      });
    });
    return count;
  }
}
