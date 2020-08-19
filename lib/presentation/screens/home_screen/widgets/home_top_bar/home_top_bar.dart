import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/domain/entities/user_details.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/user_details_bloc/user_details_bloc.dart';

import '../../../../../core/constants/measure.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../widgets/regular_text.dart';
import '../../../bottom_nav_holder/blocs/pop_address_bloc/pop_address_bloc.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({Key key}) : super(key: key);

  String _displayAddressLine(UserDetails userDetails) {
    final String city = userDetails.city;
    final String area = userDetails.area;
    return area + ', ' + city;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    PopAddressBloc popAddressBloc = context.bloc<PopAddressBloc>();
    // ignore: close_sinks
    UserDetailsBloc userDetailsBloc = context.bloc<UserDetailsBloc>();

    Measure measure = MeasureImpl(context);
    return Container(
      height: 40 + measure.bodyHeight * 0.01,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
              size: 24 * measure.fontRatio,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          GestureDetector(
            onTap: () {
              popAddressBloc.add(PopAddressEvent.show);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                BlocBuilder(
                  cubit: userDetailsBloc,
                  builder: (context, state) {
                    if (state is LoadedUserState) {
                      return Container(
                        width: measure.width * 0.6,
                        alignment: Alignment.centerRight,
                        child: RegularText(
                          text: _displayAddressLine(state.userDetails),
                          color: Colors.white,
                          fontSize: AppTheme.smallTextSize,
                          maxLines: 1,
                        ),
                      );
                    } else
                      return Container();
                  },
                ),
                SizedBox(width: measure.width * 0.02),
                Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 14 * measure.fontRatio,
                ),
                SizedBox(width: measure.width * 0.02),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
