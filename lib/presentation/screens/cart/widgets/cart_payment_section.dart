import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/presentation/screens/cart/cart_screen_bloc/cart_screen_bloc.dart';
import 'package:freshOk/presentation/screens/cart/widgets/cart_container.dart';
import 'package:freshOk/presentation/widgets/custom_button.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';

class CartPaymentSection extends StatelessWidget {
  const CartPaymentSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    CartScreenBloc cartScreenBloc = context.bloc<CartScreenBloc>();

    return CartContainer(
      border: Border.all(
        width: 0.3,
        color: Color(0x61707070),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RegularText(
            text: "Payment Mode",
            color: AppTheme.primaryColor,
            fontSize: AppTheme.extraSmallTextSize,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 5 + measure.screenHeight * 0.01),
          BlocBuilder(
            cubit: cartScreenBloc,
            builder: (context, state) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CustomButton(
                  height: 15 + measure.screenHeight * 0.02,
                  width: measure.width * 0.42,
                  onTap: () {
                    cartScreenBloc.add(
                      CartScreenPaymentEvent('cod'),
                    );
                  },
                  color: cartScreenBloc.paymentMode == 'cod'
                      ? AppTheme.primaryColor
                      : Color(0xfff5f5f5),
                  child: Center(
                    child: RegularText(
                      text: "Cash On Delivery",
                      color: cartScreenBloc.paymentMode == 'cod'
                          ? Colors.white
                          : AppTheme.black7,
                      fontSize: AppTheme.smallTextSize,
                    ),
                  ),
                ),
                CustomButton(
                  height: 15 + measure.screenHeight * 0.02,
                  width: measure.width * 0.42,
                  onTap: () {
                    cartScreenBloc.add(
                      CartScreenPaymentEvent('online'),
                    );
                  },
                  color: cartScreenBloc.paymentMode == 'online'
                      ? AppTheme.primaryColor
                      : Color(0xfff5f5f5),
                  child: Center(
                    child: RegularText(
                      text: "Online Payment",
                      color: cartScreenBloc.paymentMode == 'online'
                          ? Colors.white
                          : AppTheme.black7,
                      fontSize: AppTheme.smallTextSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
