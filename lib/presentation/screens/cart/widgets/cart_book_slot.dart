import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/measure.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/util/util.dart';
import '../../../../domain/entities/order/book_slot.dart';
import '../../../widgets/card_shimmer.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/regular_text.dart';
import '../../bottom_nav_holder/blocs/cart_bloc/cart_bloc.dart';
import '../../bottom_nav_holder/blocs/user_details_bloc/user_details_bloc.dart';
import '../cart_screen_bloc/cart_screen_bloc.dart';

const dayCodes = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

class CartBookSlot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CartScreenBloc cartScreenBloc = context.bloc<CartScreenBloc>();
    UserDetailsBloc userDetailsBloc = context.bloc<UserDetailsBloc>();
    CartBloc cartBloc = context.bloc<CartBloc>();

    Measure measure = MeasureImpl(context);
    return BlocBuilder(
      cubit: cartScreenBloc,
      builder: (context, state) => Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            height: measure.bodyHeight - 55,
            padding:
                EdgeInsets.symmetric(horizontal: 10 + measure.width * 0.02),
            child: cartScreenBloc.bookSlot == null
                //TODO make proper shimmer
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: CardShimmer(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SlotWidget(),
                        CalenderWidget(),
                        SizedBox(height: 45 + measure.screenHeight * 0.04),
                      ],
                    ),
                  ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: measure.width,
              height: 45 + measure.screenHeight * 0.04,
              alignment: Alignment.center,
              color: Colors.white,
              child: CustomButton(
                height: 25 + measure.screenHeight * 0.02,
                width: measure.width * 0.9,
                onTap: () {
                  if (state is CartScreenLoaded) {
                    cartScreenBloc.add(CartScreenToggleSlot());
                    cartScreenBloc.add(
                      CartScreenPlaceOrderEvent(
                        next: () {
                          cartBloc.add(CartClearEvent());
                        },
                        mob: userDetailsBloc.basicUser.mob.toString(),
                      ),
                    );
                  }
                },
                color: cartScreenBloc.postingCart
                    ? Colors.grey[300]
                    : AppTheme.primaryColor,
                child: Center(
                  child: cartScreenBloc.postingCart
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                AppTheme.primaryColor),
                            strokeWidth: 2,
                          ),
                        )
                      : RegularText(
                          text: "Place Order",
                          color: Colors.white,
                          fontSize: AppTheme.headingTextSize,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CalenderWidget extends StatefulWidget {
  @override
  _CalenderWidgetState createState() => _CalenderWidgetState();
}

class _CalenderWidgetState extends State<CalenderWidget> {
  CartScreenBloc _cartScreenBloc;
  DateTime todaysDate = DateTime.now();
  int selMonth;
  int selYear;

  @override
  void initState() {
    super.initState();
    _cartScreenBloc = context.bloc<CartScreenBloc>();
    if (todaysDate.day ==
        Util.getNumberOfDaysInAMonth(todaysDate.year, todaysDate.month)) {
      if (todaysDate.month == 12) {
        selMonth = 1;
        selYear = todaysDate.year + 1;
      } else {
        selMonth = todaysDate.month + 1;
        selYear = todaysDate.year;
      }
    } else {
      selMonth = todaysDate.month;
      selYear = todaysDate.year;
    }
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 25),
        RegularText(
          text: 'DELIVERY DATE',
          color: AppTheme.black3,
          fontSize: AppTheme.regularTextSize,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: 10),
        Container(
          height: measure.topBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  setState(() {
                    if (selMonth == 1) {
                      selYear--;
                      selMonth = 12;
                    } else {
                      selMonth--;
                    }
                  });
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: AppTheme.black2,
                  size: 18 * measure.fontRatio,
                ),
              ),
              RegularText(
                text: Util.getMonthName(selMonth) + ' ' + selYear.toString(),
                color: AppTheme.black2,
                fontSize: AppTheme.regularTextSize,
                fontWeight: FontWeight.w600,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (selMonth == 12) {
                      selYear++;
                      selMonth = 1;
                    } else {
                      selMonth++;
                    }
                  });
                },
                icon: Icon(
                  Icons.arrow_forward,
                  color: AppTheme.black7,
                  size: 18 * measure.fontRatio,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Column(
          children: _handleCalender(),
        )
      ],
    );
  }

  List<Widget> _handleCalender() {
    final String firstDayDate =
        selYear.toString() + selMonth.toString().padLeft(2, '0') + '01';
    final DateTime firstDay = DateTime.parse(firstDayDate);

    final int availableDaysInTodaysMonth = max(
        0, Util.getNumberOfDaysInAMonth(selYear, selMonth) - (todaysDate.day));

    int offset;
    int startDate;
    if (selMonth == todaysDate.month) {
      offset =
          min(_cartScreenBloc.bookSlot.dateOffset, availableDaysInTodaysMonth);
      startDate = todaysDate.day + 1;
    } else if (selMonth == (todaysDate.month + 1) % 12) {
      offset =
          (_cartScreenBloc.bookSlot.dateOffset) - (availableDaysInTodaysMonth);
      if (offset >= 0)
        startDate = 1;
      else
        startDate = 40;
    } else {
      offset = 0;
      startDate = 40;
    }
    return _renderCalender(firstDay, offset, startDate);
  }

  List<Widget> _renderCalender(
    DateTime firstDay,
    int offset,
    int startDate,
  ) {
    List<Widget> list = List<Widget>();
    final int noOfDays =
        Util.getNumberOfDaysInAMonth(firstDay.year, firstDay.month);

    list.add(
      Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            7,
            (index) => RegularText(
              text: dayCodes[index].padRight(3),
              color: AppTheme.black5,
              fontSize: AppTheme.regularTextSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );

    for (int i = 0; i <= 5; i++) {
      list.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _generateDays(
              i,
              noOfDays,
              firstDay.weekday,
              max(offset, 0),
              startDate,
              _cartScreenBloc.selDate,
              selMonth,
            ),
          ),
        ),
      );
    }
    return list;
  }

  List<Widget> _generateDays(
    int week,
    int noOfDays,
    int firstDay,
    int offset,
    int startDate,
    int selDate,
    int selMonth,
  ) {
    List<Widget> list = List<Widget>();

    final int additionFactor = 7 * week - firstDay + 1;

    for (int i = 1; i <= 7; ++i) {
      int thisDate = i + additionFactor;

      bool isActive = offset > 0 &&
          thisDate >= startDate &&
          thisDate < startDate + offset &&
          selMonth == _cartScreenBloc.selMonth &&
          selYear == _cartScreenBloc.selYear;
      bool isSelected = thisDate == selDate &&
          selMonth == _cartScreenBloc.selMonth &&
          selYear == _cartScreenBloc.selYear;

      Color bgColor = isSelected ? AppTheme.primaryColor : Colors.transparent;
      Color fontColor =
          isSelected ? Colors.white : isActive ? AppTheme.black2 : Colors.grey;
      FontWeight fontWeight = isSelected || isActive ? FontWeight.bold : null;

      if (week == 0) {
        if (i + additionFactor <= 0) {
          list.add(
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              child: RegularText(
                text: '01',
                color: Colors.transparent,
                fontSize: AppTheme.regularTextSize,
              ),
            ),
          );
        } else {
          list.add(
            GestureDetector(
              onTap: () {
                if (isActive)
                  _cartScreenBloc.add(
                    CartScreenSelDate(
                      date: thisDate,
                      month: selMonth,
                      year: selYear,
                    ),
                  );
              },
              child: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: RegularText(
                  text: (thisDate).toString().padLeft(2, '0'),
                  color: fontColor,
                  fontSize: AppTheme.regularTextSize,
                  fontWeight: fontWeight,
                ),
              ),
            ),
          );
        }
      } else {
        if (thisDate > noOfDays) {
          list.add(
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              child: RegularText(
                text: '01',
                color: Colors.transparent,
                fontSize: AppTheme.regularTextSize,
              ),
            ),
          );
        } else {
          list.add(
            GestureDetector(
              onTap: () {
                if (isActive)
                  _cartScreenBloc.add(
                    CartScreenSelDate(
                      date: thisDate,
                      month: selMonth,
                      year: selYear,
                    ),
                  );
              },
              child: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            blurRadius: 1,
                            offset: Offset(0, 0),
                            color: Color(0x29000000),
                          ),
                        ]
                      : [],
                ),
                child: RegularText(
                  text: (thisDate).toString().padLeft(2, '0'),
                  color: fontColor,
                  fontSize: AppTheme.regularTextSize,
                  fontWeight: fontWeight,
                ),
              ),
            ),
          );
        }
      }
    }
    return list;
  }
}

class SlotWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CartScreenBloc cartScreenBloc = context.bloc<CartScreenBloc>();
    return Container(
      padding: EdgeInsets.only(top: 25),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RegularText(
            text: 'YOUR SLOT(S)',
            color: AppTheme.black3,
            fontSize: AppTheme.regularTextSize,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 20),
          Column(
            children: _renderSlots(
              cartScreenBloc.bookSlot.slots,
              cartScreenBloc.selSlot,
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _renderSlots(List slots, String selSlot) {
    List<Widget> list = List<Widget>();

    slots.forEach((element) {
      list.add(SlotCard(slot: element, selSlot: selSlot));
    });

    return list;
  }
}

class SlotCard extends StatelessWidget {
  final Slots slot;
  final String selSlot;

  const SlotCard({
    Key key,
    this.slot,
    this.selSlot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartScreenBloc cartScreenBloc = context.bloc<CartScreenBloc>();
    bool isSelected = selSlot == slot.id ? true : false;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.1, color: Colors.black),
        borderRadius: BorderRadius.circular(4),
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 1,
            offset: Offset(0, 0),
            color: Color(0x29000000),
          )
        ],
      ),
      child: Row(
        children: <Widget>[
          Checkbox(
            value: isSelected,
            onChanged: (val) {
              if (val == true) cartScreenBloc.add(CartScreenSelSlot(slot.id));
            },
            activeColor: AppTheme.primaryColor,
          ),
          RegularText(
            text: 'Slot ' +
                slot.number.toString() +
                ' (' +
                slot.startTime +
                ' - ' +
                slot.endTime +
                ' )',
            color: AppTheme.black5,
            fontSize: AppTheme.regularTextSize,
          ),
        ],
      ),
    );
  }
}
