import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/measure.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../../core/util/util.dart';
import '../../../../../domain/entities/categories/ingredient.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/regular_text.dart';
import '../../../bottom_nav_holder/blocs/cart_bloc/cart_bloc.dart';
import '../recepie_detail_bloc/recepie_detail_bloc.dart';

class RecepieDetailIngredientsSection extends StatelessWidget {
  const RecepieDetailIngredientsSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecepieDetailBloc recepieDetailBloc = context.bloc<RecepieDetailBloc>();

    Measure measure = MeasureImpl(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10 + measure.width * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20 + measure.screenHeight * 0.02),
          RegularText(
            text: "INGREDIENTS",
            color: AppTheme.black3,
            fontSize: AppTheme.headingTextSize,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RegularText(
                text: "Serving",
                color: AppTheme.black3,
                fontSize: AppTheme.regularTextSize,
              ),
              RegularText(
                text: recepieDetailBloc.recepie.serving,
                color: AppTheme.black3,
                fontSize: AppTheme.regularTextSize,
                fontWeight: FontWeight.bold,
              )
            ],
          ),
          SizedBox(height: 25),
          Container(
            // width: measure.width * 0.98 - 20,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 0.3,
                color: Color(0x61707070),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: _renderIngredients(
                recepieDetailBloc.recepie.ingredients,
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _renderIngredients(List ingridients) {
    List<Widget> list = List<Widget>();

    for (int i = 0; i < ingridients.length; ++i) {
      list.add(
        RecepieDetailIngredientsSectionCard(
          index: i + 1,
          ingredient: ingridients[i],
        ),
      );
    }

    return list;
  }
}

class RecepieDetailIngredientsSectionCard extends StatefulWidget {
  final Ingredient ingredient;
  final int index;
  const RecepieDetailIngredientsSectionCard({
    Key key,
    @required this.index,
    @required this.ingredient,
  }) : super(key: key);

  @override
  _RecepieDetailIngredientsSectionCardState createState() =>
      _RecepieDetailIngredientsSectionCardState();
}

class _RecepieDetailIngredientsSectionCardState
    extends State<RecepieDetailIngredientsSectionCard> {
  CartBloc _cartBloc;
  RecepieDetailBloc _recepieDetailBloc;

  @override
  void initState() {
    super.initState();
    _cartBloc = context.bloc<CartBloc>();
    _recepieDetailBloc = context.bloc<RecepieDetailBloc>();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5 + measure.screenHeight * 0.01),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.2,
            color: Color(0xff707070),
          ),
        ),
      ),
      child: Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(width: 20),
              Image.network(
                widget.ingredient.image,
                width: 40 + measure.width * 0.08,
                height: (40 + measure.width * 0.08) * 0.75,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RegularText(
                    text: widget.ingredient.ingridientQuantity,
                    color: AppTheme.black2,
                    fontSize: AppTheme.regularTextSize,
                    fontWeight: FontWeight.bold,
                  ),
                  RegularText(
                    text: widget.ingredient.name,
                    color: AppTheme.black3,
                    fontSize: AppTheme.regularTextSize,
                  ),
                  // widget.ingredient.discountedPrice > 0
                  //     ? RegularText(
                  //         text: "${AppTheme.currencySymbol} " +
                  //             Util.removeDecimalZeroFormat(
                  //                 widget.ingredient.discountedPrice),
                  //         color: AppTheme.black5,
                  //         fontSize: AppTheme.smallTextSize,
                  //       )
                  //     : Container(),
                ],
              ),
              Expanded(child: Container()),
              Column(
                children: <Widget>[
                  _renderActionBtn(measure),
                  // SizedBox(height: 5),
                  // widget.ingredient.maxQty > 0 &&
                  //         widget.ingredient.checked &&
                  //         widget.ingredient.inStock
                  //     ? RegularText(
                  //         text: "min " +
                  //             Util.removeDecimalZeroFormat(
                  //                 widget.ingredient.minQty) +
                  //             widget.ingredient.unit,
                  //         color: AppTheme.black3,
                  //         fontSize: AppTheme.extraSmallTextSize,
                  //       )
                  //     : Container(),
                ],
              ),
              SizedBox(width: 5 + measure.width * 0.01),
            ],
          ),
          Container(
            width: 25,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(2),
                topRight: Radius.circular(2),
              ),
            ),
            alignment: Alignment.center,
            child: RegularText(
              text: widget.index.toString(),
              color: Colors.white,
              fontSize: AppTheme.extraSmallTextSize,
            ),
          )
        ],
      ),
    );
  }

  Widget _renderActionBtn(measure) {
    if (widget.ingredient.maxQty > 0) {
      if (!widget.ingredient.checked) {
        return RegularText(
          text: 'Unavailable',
          color: AppTheme.black7,
          fontSize: AppTheme.smallTextSize,
          fontStyle: FontStyle.italic,
        );
      }
      if (!widget.ingredient.inStock) {
        return RegularText(
          text: 'Out of Stock',
          color: AppTheme.cartRed,
          fontSize: AppTheme.smallTextSize,
          fontStyle: FontStyle.italic,
        );
      }
      if (widget.ingredient.quantity > 0) {
        // return RegularText(
        //   text: 'Added to Cart',
        //   color: AppTheme.black7,
        //   fontSize: AppTheme.smallTextSize,
        //   fontStyle: FontStyle.italic,
        // );
        //*Commented as per current requirements : 12th Aug, 2020
        return Row(
          children: <Widget>[
            CustomButton(
              height: 25,
              width: 25,
              onTap: () {
                _cartBloc.add(
                  CartDecEvent(
                    widget.ingredient,
                    (qty) {
                      _recepieDetailBloc.add(
                        RecepieDetailSetQty(
                          ingredient: widget.ingredient,
                          qty: qty,
                        ),
                      );
                    },
                  ),
                );
              },
              color: AppTheme.lightGreen,
              child: Center(
                child: Icon(
                  Icons.remove,
                  color: Colors.white,
                  size: 18 * measure.fontRatio,
                ),
              ),
            ),
            Container(
              height: 25,
              width: 25,
              alignment: Alignment.center,
              child: RegularText(
                text: Util.removeDecimalZeroFormat(widget.ingredient.quantity),
                color: AppTheme.black2,
                fontSize: AppTheme.smallTextSize,
              ),
            ),
            CustomButton(
              height: 25,
              width: 25,
              onTap: () {
                _cartBloc.add(
                  CartIncEvent(
                    widget.ingredient,
                    (qty) {
                      _recepieDetailBloc.add(
                        RecepieDetailSetQty(
                          ingredient: widget.ingredient,
                          qty: qty,
                        ),
                      );
                    },
                  ),
                );
              },
              color: AppTheme.darkGreen,
              child: Center(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 18 * measure.fontRatio,
                ),
              ),
            ),
          ],
        );
      } else {
        return CustomButton(
          height: 25,
          width: 80,
          onTap: () {
            _cartBloc.add(
              CartIncEvent(
                widget.ingredient,
                (qty) {
                  _recepieDetailBloc.add(
                    RecepieDetailSetQty(
                      ingredient: widget.ingredient,
                      qty: qty,
                    ),
                  );
                },
              ),
            );
          },
          color: AppTheme.primaryColor,
          child: Center(
            child: RegularText(
              text: "ADD TO CART",
              color: Colors.white,
              fontSize: AppTheme.extraSmallTextSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }
    } else {
      return Container();
    }
  }
}
