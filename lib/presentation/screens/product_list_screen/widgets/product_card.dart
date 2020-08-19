import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/measure.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/util/util.dart';
import '../../../../domain/entities/categories/product.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/regular_text.dart';
import '../../bottom_nav_holder/blocs/cart_bloc/cart_bloc.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({Key key, @required this.product}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  CartBloc _cartBloc;
  Product product;

  @override
  void initState() {
    super.initState();
    _cartBloc = context.bloc<CartBloc>();
    setState(() {
      product = widget.product;
    });
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 2 + measure.screenHeight * 0.005,
        horizontal: 10,
      ),
      margin: EdgeInsets.symmetric(vertical: 2 + measure.screenHeight * 0.005),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 1,
            color: Color(0x29000000),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 70 + measure.width * 0.04,
            height: 70 + measure.width * 0.04 * 0.75,
            child: Image.network(
              product.image,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    RegularText(
                      text:
                          "${AppTheme.currencySymbol}${Util.removeDecimalZeroFormat(product.discountedPrice)}",
                      color: AppTheme.black2,
                      fontSize: AppTheme.regularTextSize,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(width: 5),
                    product.discountedPrice != product.unitPrice
                        ? RegularText(
                            text:
                                "${AppTheme.currencySymbol}${Util.removeDecimalZeroFormat(product.unitPrice)}",
                            color: AppTheme.black7,
                            fontSize: AppTheme.smallTextSize,
                            decoration: TextDecoration.lineThrough,
                          )
                        : Container(),
                    SizedBox(width: 10),
                    product.discount > 0
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(2)),
                            child: RegularText(
                              text:
                                  "${Util.removeDecimalZeroFormat(product.discount)}% OFF",
                              color: Colors.white,
                              fontSize: AppTheme.extraSmallTextSize,
                            ),
                          )
                        : Container(),
                  ],
                ),
                RegularText(
                  text: product.name,
                  color: AppTheme.black2,
                  fontSize: AppTheme.regularTextSize + 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //Required for design
                        RegularText(
                          text: "placeholder",
                          color: Colors.transparent,
                          fontSize: AppTheme.regularTextSize,
                        ),
                        RegularText(
                          text:
                              '${Util.removeDecimalZeroFormat(product.unitQty)} ${product.unit}',
                          color: AppTheme.black5,
                          fontSize: AppTheme.smallTextSize,
                        ),
                      ],
                    ),
                    _renderActionBtns(measure),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _renderActionBtns(measure) {
    if (product.inStock == false) {
      return Container();
    }

    if (product.quantity == 0)
      return CustomButton(
        height: 25,
        width: 85,
        onTap: () {
          _cartBloc.add(
            CartIncEvent(
              widget.product,
              (qty) {
                setState(() {
                  product.quantity = qty;
                });
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
          ),
        ),
      );
    return Row(
      children: <Widget>[
        CustomButton(
          height: 25,
          width: 25,
          onTap: () {
            _cartBloc.add(
              CartDecEvent(
                widget.product,
                (qty) {
                  setState(() {
                    product.quantity = qty;
                  });
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
        SizedBox(
          height: 25,
          width: 25,
          child: Center(
            child: RegularText(
              text: Util.removeDecimalZeroFormat(product.quantity),
              color: AppTheme.black2,
              fontSize: AppTheme.regularTextSize,
            ),
          ),
        ),
        CustomButton(
          height: 25,
          width: 25,
          onTap: () {
            _cartBloc.add(
              CartIncEvent(
                widget.product,
                (qty) {
                  setState(() {
                    product.quantity = qty;
                  });
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
  }
}
