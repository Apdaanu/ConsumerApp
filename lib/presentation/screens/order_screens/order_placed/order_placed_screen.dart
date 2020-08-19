import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/core/constants/routes.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/bottom_nav/bottom_nav_bloc.dart';
import 'package:freshOk/presentation/widgets/display_screen.dart';
import 'package:freshOk/presentation/widgets/no_items_widget.dart';
import 'package:freshOk/presentation/widgets/top_bar.dart';

class OrderPlacedScreen extends StatelessWidget {
  final String orderId;

  const OrderPlacedScreen({Key key, this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BottomNavBloc bottomNavBloc = context.bloc<BottomNavBloc>();
    return DisplayScreen(
      topBar: CustomTopBar(
        title: 'Order Placed',
        altBackFxn: () {
          Navigator.of(context).popUntil(ModalRoute.withName(homeRoute));
          bottomNavBloc.add(0);
        },
      ),
      body: NoItemsWidget(
        title: 'ORDER PLACED',
        image: 'assets/images/order_placed.png',
        description: 'Yippe ! Your order has been placed successfully',
        buttonText: 'Back To Store',
        btnFxn: () {
          Navigator.of(context).popUntil(ModalRoute.withName(homeRoute));
          bottomNavBloc.add(0);
        },
        btnColor: AppTheme.primaryColor,
        altBtnText: 'View order details',
        altBtnFxn: () {
          Navigator.of(context).popUntil(ModalRoute.withName(homeRoute));
          bottomNavBloc.add(0);
          Navigator.pushNamed(
            context,
            orderDetailsRoute,
            arguments: orderId,
          );
        },
      ),
      failure: false,
      failureCode: 0,
    );
  }
}
