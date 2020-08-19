import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/measure.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/util/util.dart';
import '../../../../injection_container.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/display_screen.dart';
import '../../../widgets/regular_text.dart';
import '../../../widgets/top_bar.dart';
import '../../bottom_nav_holder/blocs/user_details_bloc/user_details_bloc.dart';
import 'bloc/order_details_bloc.dart';
import 'widgets/order_details_billing.dart';
import 'widgets/order_details_fresh_mitra.dart';
import 'widgets/order_details_item_summary.dart';
import 'widgets/order_details_payment_details.dart';
import 'widgets/order_details_progress_steps.dart';
import 'widgets/order_details_shimmer.dart';
import 'widgets/order_details_slot.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailsScreen({
    Key key,
    @required this.orderId,
  }) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  OrderDetailsBloc _orderDetailsBloc;
  UserDetailsBloc _userDetailsBloc;

  @override
  void initState() {
    super.initState();
    _orderDetailsBloc = sl<OrderDetailsBloc>();
    _userDetailsBloc = context.bloc<UserDetailsBloc>();
    _orderDetailsBloc.add(OrderDetailsInitEvent(
      orderId: widget.orderId,
      userId: _userDetailsBloc.userDetails.userId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return DisplayScreen(
      topBar: CustomTopBar(
        lightTheme: false,
        title: "Order Details",
      ),
      body: BlocBuilder(
        cubit: _orderDetailsBloc,
        builder: (context, state) {
          if (state is OrderDetailsLoaded) {
            final orderDate = Util.getDateFromUTC(state.order.orderDate);
            return Stack(
              children: <Widget>[
                Container(
                  height: measure.bodyHeight,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: measure.bodyHeight * 0.99 - 50,
                        color: Color(0xfffbfbfb),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 5 + measure.screenHeight * 0.01),
                              RegularText(
                                text:
                                    "Placed on ${orderDate['date']}, ${orderDate['time']}",
                                color: AppTheme.black7,
                                fontSize: AppTheme.smallTextSize,
                              ),
                              SizedBox(height: 5 + measure.screenHeight * 0.01),
                              OrderDetailsProgressSteps(
                                orderStatus: state.order.orderStatus,
                              ),
                              OrderDetailsSlot(
                                slot: state.order.slot,
                                slotDate: state.order.slotDate,
                                status: state.order.orderStatus[
                                    state.order.orderStatus.length - 1],
                              ),
                              SizedBox(
                                  height: 10 + measure.screenHeight * 0.01),
                              OrderDetailsPaymentDetails(
                                paymentMethod: state.order.paymentMethod,
                              ),
                              SizedBox(
                                  height: 10 + measure.screenHeight * 0.01),
                              OrderDetailsItemSummary(
                                order: state.order,
                              ),
                              SizedBox(
                                  height: 10 + measure.screenHeight * 0.01),
                              OrderDetailsBilling(
                                order: state.order,
                              ),
                              SizedBox(
                                  height: 10 + measure.screenHeight * 0.01),
                              OrderDetailsFreshMitra(
                                mitraDetails: state.order.mitraDetails,
                              ),
                              SizedBox(
                                  height: 10 + measure.screenHeight * 0.01),
                              BlocProvider.value(
                                value: _orderDetailsBloc,
                                child: OrderDetailsCancelOrderButton(),
                              ),
                              SizedBox(
                                  height: 10 + measure.screenHeight * 0.01),
                            ],
                          ),
                        ),
                      ),
                      CustomButton(
                        height: measure.bodyHeight * 0.01 + 50,
                        width: measure.width,
                        onTap: () {
                          launch('tel://${state.order.mitraDetails.mob}');
                        },
                        color: AppTheme.primaryColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.phone,
                              color: Colors.white,
                              size: 18 * measure.fontRatio,
                            ),
                            SizedBox(width: 10),
                            RegularText(
                              text: "freshMitra",
                              color: Colors.white,
                              fontSize: AppTheme.regularTextSize,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Positioned(
                //   bottom: 0,
                //   child: Container(
                //     height: measure.bodyHeight,
                //     width: measure.width,
                //     color: Color(0x29000000),
                //     child: Column(
                //       children: <Widget>[
                //         Container(
                //           height: measure.bodyHeight * 0.35,
                //         ),
                //         Container(
                //           height: measure.bodyHeight * 0.3,
                //           width: measure.width * 0.8,
                //           decoration: BoxDecoration(
                //               color: Colors.white,
                //               borderRadius: BorderRadius.circular(4),
                //               boxShadow: <BoxShadow>[
                //                 BoxShadow(
                //                   blurRadius: 2,
                //                   color: Color(0xaa707070),
                //                   offset: Offset(0, 0),
                //                 ),
                //               ]),
                //           child: Column(
                //             children: <Widget>[

                //             ],
                //           ),
                //         ),
                //         Container(
                //           height: measure.bodyHeight * 0.35,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            );
          }
          return OrderDetailsShimmer();
        },
      ),
      failure: false,
      failureCode: 0,
    );
  }
}

class OrderDetailsCancelOrderButton extends StatefulWidget {
  @override
  _OrderDetailsCancelOrderButtonState createState() =>
      _OrderDetailsCancelOrderButtonState();
}

class _OrderDetailsCancelOrderButtonState
    extends State<OrderDetailsCancelOrderButton> {
  OrderDetailsBloc _orderDetailsBloc;

  @override
  void initState() {
    super.initState();
    _orderDetailsBloc = context.bloc<OrderDetailsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return BlocBuilder(
      cubit: _orderDetailsBloc,
      builder: (context, state) {
        if (state is OrderDetailsLoaded) {
          if (state.order.orderStatus[state.order.orderStatus.length - 1]
                  .indexOf('Cancelled') ==
              -1) {
            return CustomButton(
              height: 50,
              width: measure.width * 0.98 - 20,
              onTap: () {
                showAlertDialog(context);
              },
              child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      width: 0.1,
                      color: Color(0xff707070),
                    ),
                  ),
                  child: !_orderDetailsBloc.cancelling
                      ? RegularText(
                          text: "Cancel Order",
                          color: AppTheme.black7,
                          fontSize: AppTheme.smallTextSize,
                        )
                      : SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            valueColor: new AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryColor,
                            ),
                          ),
                        )),
              color: AppTheme.greyFB,
            );
          } else {
            return Container();
          }
        }
      },
    );
  }

  void showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: RegularText(
        text: 'Yes',
        color: Colors.grey,
        fontSize: AppTheme.regularTextSize,
        fontWeight: FontWeight.bold,
      ),
      onPressed: () {
        _orderDetailsBloc.add(CancelOrderEvent());
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: RegularText(
        text: 'No',
        color: AppTheme.primaryColor,
        fontSize: AppTheme.regularTextSize,
        fontWeight: FontWeight.bold,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: RegularText(
        text: 'Are you sure?',
        color: AppTheme.black2,
        fontSize: AppTheme.headingTextSize,
        fontWeight: FontWeight.w700,
      ),
      content: RegularText(
        text:
            "Pressing 'Yes' will cancel your order.\nWe hope to serve you better next time.",
        color: AppTheme.black5,
        fontSize: AppTheme.regularTextSize,
        overflow: false,
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
