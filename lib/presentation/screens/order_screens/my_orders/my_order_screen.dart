import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/bottom_nav/bottom_nav_bloc.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/user_details_bloc/user_details_bloc.dart';
import 'package:freshOk/presentation/widgets/card_shimmer.dart';
import 'package:freshOk/presentation/widgets/loader.dart';
import 'package:freshOk/presentation/widgets/no_items_widget.dart';
import '../../bottom_nav_holder/blocs/order_bloc/order_bloc.dart';

import '../../../../core/constants/measure.dart';
import '../../../../core/theme/theme.dart';
import '../../../widgets/regular_text.dart';
import 'widgets/order_card.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({Key key}) : super(key: key);

  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  OrderBloc _orderBloc;
  UserDetailsBloc _userDetailsBloc;
  BottomNavBloc _bottomNavBloc;

  @override
  void initState() {
    super.initState();
    _orderBloc = context.bloc<OrderBloc>();
    _userDetailsBloc = context.bloc<UserDetailsBloc>();
    _bottomNavBloc = context.bloc<BottomNavBloc>();

    _orderBloc.add(OrderInitEvent(_userDetailsBloc.userDetails.userId));
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      color: Color(0xfffbfbfb),
      child: BlocBuilder(
        cubit: _orderBloc,
        builder: (context, state) {
          if (state is OrderLoading) {
            return ListView(
              children:
                  List.generate(9, (index) => CardShimmer(lag: index * 10)),
            );
          } else if (state is OrderLoaded) {
            if (state.orders.length > 0) {
              return ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10 + measure.screenHeight * 0.02,
                      horizontal: 5 + measure.width * 0.02,
                    ),
                    child: RegularText(
                      text: "My Orders",
                      color: AppTheme.black3,
                      fontSize: AppTheme.extraLargeHeading,
                    ),
                  ),
                  Column(
                    children: _renderOrders(state.orders),
                  ),
                ],
              );
            } else {
              return NoItemsWidget(
                btnFxn: () {
                  _bottomNavBloc.add(0);
                },
                buttonText: 'Browse Products',
                btnColor: Color(0xffe07156),
                description:
                    'You haven\'t placed any order yet, place one today...',
                image: 'assets/images/orders_empty.png',
                title: 'NO ORDERS',
              );
            }
          }
          return Container();
        },
      ),
    );
  }

  List<Widget> _renderOrders(List orders) {
    List<Widget> list = List<Widget>();
    orders.forEach((element) {
      list.add(OrderCard(order: element));
    });
    return list;
  }
}
