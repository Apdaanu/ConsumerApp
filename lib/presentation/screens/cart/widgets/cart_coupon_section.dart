import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/measure.dart';
import '../../../../core/theme/theme.dart';
import '../../../widgets/regular_text.dart';
import '../../bottom_nav_holder/blocs/pop_lock_bloc/pop_lock_bloc.dart';
import '../cart_screen_bloc/cart_screen_bloc.dart';
import 'cart_container.dart';

class CartCouponSection extends StatelessWidget {
  const CartCouponSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartScreenBloc cartScreenBloc = context.bloc();
    PopLockBloc popLockBloc = context.bloc<PopLockBloc>();

    Measure measure = MeasureImpl(context);

    return GestureDetector(
      onTap: () {
        popLockBloc.add(
          PopLockAcquire(
            () {
              cartScreenBloc.add(CartScreenToggleCoupons());
            },
          ),
        );
        cartScreenBloc.add(CartScreenToggleCoupons());
      },
      child: CartContainer(
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
        child: BlocBuilder(
          cubit: cartScreenBloc,
          builder: (context, state) => Row(
            children: <Widget>[
              SizedBox(width: 10),
              cartScreenBloc.selCoupon != null
                  ? Icon(
                      Icons.done_all,
                      color: AppTheme.primaryColor,
                      size: 18 * measure.fontRatio,
                    )
                  : Icon(
                      Icons.local_offer,
                      color: AppTheme.black7,
                      size: 18 * measure.fontRatio,
                    ),
              SizedBox(width: 20),
              RegularText(
                text: cartScreenBloc.selCoupon != null
                    ? 'COUPON APPLIED'
                    : 'APPLY COUPON',
                color: cartScreenBloc.selCoupon != null
                    ? AppTheme.primaryColor
                    : AppTheme.black7,
                fontSize: AppTheme.regularTextSize,
              ),
              Expanded(
                child: Container(),
              ),
              Icon(
                Icons.chevron_right,
                color: AppTheme.black7,
                size: 18 * measure.fontRatio,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
