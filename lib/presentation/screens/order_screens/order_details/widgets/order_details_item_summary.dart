import 'package:flutter/material.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/core/util/util.dart';
import 'package:freshOk/domain/entities/categories/product.dart';
import 'package:freshOk/domain/entities/order/order.dart';
import 'package:freshOk/presentation/screens/order_screens/order_details/widgets/order_details_section_container.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';

class OrderDetailsItemSummary extends StatelessWidget {
  final Order order;

  const OrderDetailsItemSummary({
    Key key,
    @required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return OrderDetailsSectionContainer(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
                vertical: 2 + measure.screenHeight * 0.005),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.2,
                  color: Color(0xff707070),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RegularText(
                  text:
                      "${order.order.length} Item${order.order.length == 1 ? '' : 's'}    .    Amount  ${AppTheme.currencySymbol}${Util.getMoneyValuesFromOrder(
                    coupon: order.discount,
                    deliveryCharges: order.deliveryCharges,
                    order: order.order,
                    usedFreshOkCredit: order.usedFreshOkCredit,
                  )['itemTotal']}",
                  color: AppTheme.black7,
                  fontSize: AppTheme.smallTextSize,
                ),
              ],
            ),
          ),
          Column(
            children: _renderItems(),
          )
        ],
      ),
    );
  }

  List<Widget> _renderItems() {
    List<Widget> list = List<Widget>();
    order.order.forEach((element) {
      list.add(OrderDetailsItemSummaryItemDetails(product: element));
    });
    return list;
  }
}

class OrderDetailsItemSummaryItemDetails extends StatelessWidget {
  final Product product;

  const OrderDetailsItemSummaryItemDetails({
    Key key,
    @required this.product,
  }) : super(key: key);

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 50 + measure.width * 0.01,
            width: 50 + measure.width * 0.01,
            color: Colors.transparent,
            child: Image.network(
              product.image,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 5 + measure.width * 0.04),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RegularText(
                text: product.name ?? '',
                color: AppTheme.black2,
                fontSize: AppTheme.regularTextSize,
              ),
              RegularText(
                text: Util.removeDecimalZeroFormat(product.unitQty) +
                    product.unit,
                color: AppTheme.black7,
                fontSize: AppTheme.extraSmallTextSize,
              ),
              Row(
                children: <Widget>[
                  RegularText(
                    text: AppTheme.currencySymbol +
                        Util.removeDecimalZeroFormat(product.discountedPrice),
                    color: AppTheme.black7,
                    fontSize: AppTheme.smallTextSize,
                  ),
                  RegularText(
                    text:
                        " X " + Util.removeDecimalZeroFormat(product.quantity),
                    color: AppTheme.black2,
                    fontSize: AppTheme.smallTextSize,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ],
          ),
          Expanded(child: Container()),
          RegularText(
            text: AppTheme.currencySymbol +
                Util.removeDecimalZeroFormat(
                    product.discountedPrice * product.quantity),
            color: AppTheme.black2,
            fontSize: AppTheme.regularTextSize,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}
