import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/presentation/widgets/card_shimmer.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/util/util.dart';
import '../../../widgets/regular_text.dart';
import '../cart_screen_bloc/cart_screen_bloc.dart';
import 'cart_container.dart';

class CartCreditsSection extends StatelessWidget {
  const CartCreditsSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartScreenBloc cartScreenBloc = context.bloc<CartScreenBloc>();
    return CartContainer(
      noPadding: true,
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
            final costs = Util.getMoneyValuesFromOrder(
              coupon: null,
              deliveryCharges: state.cart.deliveryCharges,
              order: state.cart.cart,
              usedFreshOkCredit: 0,
            );

            final double itemTotal = double.parse(costs['itemTotal']);

            double freshOkCredits = min(
                    itemTotal * cartScreenBloc.cart.creditLimit,
                    cartScreenBloc.freshOkCredit)
                .floor()
                .toDouble();

            if (freshOkCredits < 0) freshOkCredits = 0;

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: cartScreenBloc.useCredits,
                    onChanged: (bool val) {
                      cartScreenBloc.add(CartScreenToggleCredits());
                    },
                    activeColor: AppTheme.primaryColor,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  SizedBox(width: 10),
                  RegularText(
                    text: "freshOk Credits",
                    color: AppTheme.black7,
                    fontSize: AppTheme.regularTextSize,
                  ),
                  Expanded(child: Container()),
                  RegularText(
                    text: "${AppTheme.currencySymbol}" +
                        (cartScreenBloc.useCredits
                            ? Util.removeDecimalZeroFormat(freshOkCredits)
                            : '0'),
                    color: AppTheme.black7,
                    fontSize: AppTheme.regularTextSize,
                  ),
                  SizedBox(width: 5),
                ],
              ),
            );
          }
          return CardShimmer();
        },
      ),
    );
  }
}
