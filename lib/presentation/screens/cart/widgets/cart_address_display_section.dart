import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/pop_address_bloc/pop_address_bloc.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/user_details_bloc/user_details_bloc.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';

class CartAddressDisplaySection extends StatefulWidget {
  const CartAddressDisplaySection({Key key}) : super(key: key);

  @override
  _CartAddressDisplaySectionState createState() =>
      _CartAddressDisplaySectionState();
}

class _CartAddressDisplaySectionState extends State<CartAddressDisplaySection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PopAddressBloc _popAddressBloc = context.bloc<PopAddressBloc>();

    Measure measure = MeasureImpl(context);
    return GestureDetector(
      onTap: () {
        _popAddressBloc.add(PopAddressEvent.show);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2),
        padding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 5 + measure.width * 0.01,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2),
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 1,
              offset: Offset(0, 0),
              color: Color(0x29000000),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            BlocBuilder<UserDetailsBloc, UserDetailsState>(
              builder: (context, state) {
                if (state is LoadedUserState) {
                  return SizedBox(
                    width: measure.width * 0.8,
                    child: RegularText(
                      text: state.userDetails.address != null &&
                              state.userDetails.address.length > 0
                          ? state.userDetails.address
                          : 'unnamed road',
                      color: AppTheme.black5,
                      fontSize: AppTheme.smallTextSize,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }
                return RegularText(
                  text: 'unnamed road',
                  color: AppTheme.black5,
                  fontSize: AppTheme.smallTextSize,
                  fontWeight: FontWeight.w600,
                );
              },
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: AppTheme.black5,
              size: 18 * measure.fontRatio,
            ),
          ],
        ),
      ),
    );
  }
}
