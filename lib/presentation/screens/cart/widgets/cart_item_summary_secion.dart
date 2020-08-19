import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/core/util/util.dart';
import 'package:freshOk/domain/entities/categories/product.dart';
import 'package:freshOk/domain/entities/order/cart.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/cart_bloc/cart_bloc.dart';
import 'package:freshOk/presentation/screens/cart/cart_screen_bloc/cart_screen_bloc.dart';
import 'package:freshOk/presentation/screens/cart/widgets/cart_container.dart';
import 'package:freshOk/presentation/widgets/card_shimmer.dart';
import 'package:freshOk/presentation/widgets/custom_button.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';

class CartItemSummarySection extends StatefulWidget {
  const CartItemSummarySection({Key key}) : super(key: key);

  @override
  _CartItemSummarySectionState createState() => _CartItemSummarySectionState();
}

class _CartItemSummarySectionState extends State<CartItemSummarySection> {
  CartScreenBloc _cartScreenBloc;

  @override
  void initState() {
    super.initState();
    _cartScreenBloc = context.bloc();
  }

  @override
  Widget build(BuildContext context) {
    return CartContainer(
      border: Border.all(
        width: 0.1,
        color: Color(0xff707070),
      ),
      boxShadow: <BoxShadow>[
        BoxShadow(
          blurRadius: 1,
          offset: Offset(0, 0),
          color: Color(0x29000000),
        )
      ],
      child: BlocBuilder<CartScreenBloc, CartScreenState>(
        builder: (context, state) {
          if (state is CartScreenLoaded) {
            return Column(
              children: _renderItems(state.cart.cart),
            );
          }
          return Container(
            child: Column(
              children: List.generate(
                4,
                (index) {
                  return Container(
                    child: CardShimmer(lag: index * 10),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _renderItems(List products) {
    List<Widget> list = List<Widget>();
    products.forEach((element) {
      list.add(CartItemSummaryCard(product: element));
    });
    return list;
  }
}

class CartItemSummaryCard extends StatefulWidget {
  final Product product;

  const CartItemSummaryCard({Key key, this.product}) : super(key: key);

  @override
  _CartItemSummaryCardState createState() => _CartItemSummaryCardState();
}

class _CartItemSummaryCardState extends State<CartItemSummaryCard> {
  CartBloc _cartBloc;
  CartScreenBloc _cartScreenBloc;

  @override
  void initState() {
    super.initState();
    _cartBloc = context.bloc<CartBloc>();
    _cartScreenBloc = context.bloc<CartScreenBloc>();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7 + measure.screenHeight * 0.005),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.1,
            color: Color(0xff707070),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _cartBloc.add(
                    CartRemEvent(
                      widget.product,
                      () {
                        _cartScreenBloc.add(
                          CartScreenRemQty(widget.product),
                        );
                      },
                    ),
                  );
                },
                child: Icon(
                  Icons.delete_outline,
                  color: AppTheme.cartRed,
                  size: 18 * measure.fontRatio,
                ),
              ),
              SizedBox(width: 10 + measure.width * 0.01),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RegularText(
                    text: widget.product.name,
                    color: AppTheme.black3,
                    fontSize: AppTheme.regularTextSize,
                  ),
                  RegularText(
                    text:
                        "${AppTheme.currencySymbol}${Util.removeDecimalZeroFormat(widget.product.discountedPrice)} per ${Util.removeDecimalZeroFormat(widget.product.unitQty)}${widget.product.unit}",
                    color: AppTheme.black7,
                    fontSize: AppTheme.extraSmallTextSize,
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CustomButton(
                    height: 22 + measure.width * 0.01,
                    width: 22 + measure.width * 0.01,
                    onTap: () {
                      if (widget.product.quantity > widget.product.minQty)
                        _cartBloc.add(
                          CartDecEvent(
                            widget.product,
                            (val) {
                              _cartScreenBloc.add(
                                CartScreenDecQty(widget.product),
                              );
                            },
                          ),
                        );
                    },
                    color: Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 2, color: AppTheme.primaryColor),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.remove,
                        color: AppTheme.primaryColor,
                        size: 16 * measure.fontRatio,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: Center(
                      child: RegularText(
                        text: Util.removeDecimalZeroFormat(
                            widget.product.quantity),
                        color: AppTheme.primaryColor,
                        fontSize: AppTheme.regularTextSize,
                        fontWeight: FontWeight.w600,
                        overflow: false,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  CustomButton(
                    height: 22 + measure.width * 0.01,
                    width: 22 + measure.width * 0.01,
                    onTap: () {
                      _cartBloc.add(
                        CartIncEvent(
                          widget.product,
                          (val) {
                            _cartScreenBloc.add(
                              CartScreenIncQty(widget.product),
                            );
                          },
                        ),
                      );
                    },
                    color: Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 2, color: AppTheme.primaryColor),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.add,
                        color: AppTheme.primaryColor,
                        size: 16 * measure.fontRatio,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 55,
                    alignment: Alignment.centerRight,
                    child: RegularText(
                      text:
                          "${AppTheme.currencySymbol}${Util.removeDecimalZeroFormat(widget.product.quantity * widget.product.discountedPrice)}",
                      color: AppTheme.black7,
                      fontSize: AppTheme.regularTextSize,
                    ),
                  ),
                  SizedBox(width: 5),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
