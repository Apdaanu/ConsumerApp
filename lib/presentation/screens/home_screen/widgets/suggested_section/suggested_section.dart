import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/core/util/util.dart';
import 'package:freshOk/domain/entities/categories/product.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/cart_bloc/cart_bloc.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/suggested_products_bloc/suggested_products_bloc.dart';
import 'package:freshOk/presentation/widgets/custom_button.dart';

import '../../../../../core/constants/measure.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../widgets/regular_text.dart';

class SuggestedSection extends StatefulWidget {
  @override
  _SuggestedSectionState createState() => _SuggestedSectionState();
}

class _SuggestedSectionState extends State<SuggestedSection> {
  SuggestedProductsBloc _suggestedProductsBloc;
  CartBloc _cartBloc;

  @override
  void initState() {
    super.initState();
    _suggestedProductsBloc = context.bloc<SuggestedProductsBloc>();
    _cartBloc = context.bloc<CartBloc>();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return BlocListener(
      cubit: _cartBloc,
      listener: (context, state) {
        if (state is CartLoaded) {
          _suggestedProductsBloc.add(
            SuggestedProductInitCart(state.cart),
          );
        }
      },
      child: BlocBuilder(
        cubit: _suggestedProductsBloc,
        builder: (context, state) {
          if (state is SuggestedProductsLoaded) {
            _suggestedProductsBloc.add(
              SuggestedProductInitCart(_cartBloc.cart),
            );
          }

          if (state is SuggestedProductsLoaded && state.products.length == 0) {
            return Container();
          }

          return Container(
            // color: Color(0xffe4e4e4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 15 + measure.screenHeight * 0.01),
                Padding(
                  padding: EdgeInsets.only(left: measure.width * 0.02),
                  child: RegularText(
                    text: 'Suggested',
                    color: AppTheme.black3,
                    fontSize: AppTheme.regularTextSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5 + measure.screenHeight * 0.01),
                Container(
                  width: measure.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: state is SuggestedProductsLoaded
                        ? Row(
                            children: _renderProducts(state.products),
                          )
                        : Container(),
                  ),
                ),
                SizedBox(height: 15 + measure.screenHeight * 0.01),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _renderProducts(List products) {
    List<Widget> list = List<Widget>();
    products.forEach((element) {
      list.add(SuggestedSectionCard(
        product: element,
      ));
    });
    return list;
  }
}

class SuggestedSectionCard extends StatelessWidget {
  final Product product;
  const SuggestedSectionCard({
    Key key,
    this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartBloc cartBloc = context.bloc<CartBloc>();
    SuggestedProductsBloc suggestedProductsBloc =
        context.bloc<SuggestedProductsBloc>();
    Measure measure = MeasureImpl(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        width: 120 + measure.width * 0.05,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 5 + measure.width * 0.01),
        padding: EdgeInsets.symmetric(horizontal: measure.width * 0.02),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: Offset(0, 0),
              blurRadius: 1.0,
              color: Color(0x1c000000),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: measure.width * 0.02),
            Container(
              width: 120 + measure.width * 0.03,
              height: (120 + measure.width * 0.01) * 0.75,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: Image.network(product.image).image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: measure.screenHeight * 0.005),
            RegularText(
              text: product.name,
              color: AppTheme.black2,
              fontSize: AppTheme.regularTextSize,
            ),
            Row(
              children: <Widget>[
                RegularText(
                  text: AppTheme.currencySymbol +
                      Util.removeDecimalZeroFormat(product.discountedPrice),
                  color: AppTheme.primaryColor,
                  fontSize: AppTheme.regularTextSize,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(width: 5),
                product.discount != 0
                    ? RegularText(
                        text: AppTheme.currencySymbol +
                            Util.removeDecimalZeroFormat(product.unitPrice),
                        color: AppTheme.black7,
                        fontSize: AppTheme.smallTextSize,
                        decoration: TextDecoration.lineThrough,
                      )
                    : Container(),
              ],
            ),
            SizedBox(height: measure.screenHeight * 0.01),
            product.quantity == 0
                ? CustomButton(
                    height: 20 + measure.screenHeight * 0.01,
                    width: 120 + measure.width * 0.03,
                    onTap: () {
                      cartBloc.add(
                        CartIncEvent(
                          product,
                          (val) {
                            suggestedProductsBloc.add(
                              UpdateProductQty(
                                product: product,
                                qty: val,
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
                        fontSize: AppTheme.smallTextSize,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CustomButton(
                        height: 20 + measure.screenHeight * 0.01,
                        width: 20 + measure.screenHeight * 0.01,
                        onTap: () {
                          cartBloc.add(
                            CartDecEvent(
                              product,
                              (val) {
                                suggestedProductsBloc.add(
                                  UpdateProductQty(
                                    product: product,
                                    qty: val,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        color: AppTheme.primaryColor,
                        child: Center(
                          child: Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 18 * measure.fontRatio,
                          ),
                        ),
                      ),
                      Container(
                        height: 20 + measure.screenHeight * 0.01,
                        width: 20 + measure.screenHeight * 0.01,
                        child: Center(
                          child: RegularText(
                            text:
                                Util.removeDecimalZeroFormat(product.quantity),
                            color: AppTheme.black2,
                            fontSize: AppTheme.regularTextSize,
                          ),
                        ),
                      ),
                      CustomButton(
                        height: 20 + measure.screenHeight * 0.01,
                        width: 20 + measure.screenHeight * 0.01,
                        onTap: () {
                          cartBloc.add(
                            CartIncEvent(
                              product,
                              (val) {
                                suggestedProductsBloc.add(
                                  UpdateProductQty(
                                    product: product,
                                    qty: val,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        color: AppTheme.primaryColor,
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 18 * measure.fontRatio,
                          ),
                        ),
                      ),
                    ],
                  ),
            SizedBox(height: measure.width * 0.02),
          ],
        ),
      ),
    );
  }
}
