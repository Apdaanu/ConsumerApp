import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/measure.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../widgets/card_shimmer.dart';
import '../../../../widgets/regular_text.dart';
import '../../../bottom_nav_holder/blocs/mitra_bloc/mitra_bloc.dart';
import 'select_mitra_card.dart';

class SelectMitraMyMitraSection extends StatefulWidget {
  @override
  _SelectMitraMyMitraSectionState createState() => _SelectMitraMyMitraSectionState();
}

class _SelectMitraMyMitraSectionState extends State<SelectMitraMyMitraSection> {
  MitraBloc _mitraBloc;

  @override
  void initState() {
    super.initState();
    _mitraBloc = context.bloc<MitraBloc>();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return BlocBuilder<MitraBloc, MitraState>(
      builder: (context, state) {
        if (state is MitraLoading) {
          return Container(
            margin: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 10 + measure.width * 0.02,
            ),
            child: CardShimmer(),
          );
        }
        if (state is MitraLoaded) {
          return Container(
            height: 140,
            width: measure.width,
            padding: EdgeInsets.symmetric(horizontal: 10 + measure.width * 0.02),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.2,
                  color: Color(0xff707070),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    RegularText(
                      text: "Your freshMitra",
                      color: AppTheme.black7,
                      fontSize: AppTheme.extraSmallTextSize,
                      fontWeight: FontWeight.w700,
                    ),
                    if (_mitraBloc.selMitra == null || !_mitraBloc.selMitra.active)
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: CircleAvatar(
                          radius: 6,
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.priority_high,
                            color: Colors.white,
                            size: 8,
                          ),
                        ),
                      ),
                    SizedBox(width: 10),
                    state.postingMitra == true
                        ? SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                AppTheme.primaryColor,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                SizedBox(height: 10),
                if (_mitraBloc.selMitra != null)
                  SelectMitraCard(
                    bgColor: AppTheme.cartSecondary,
                    textColor: Colors.white,
                    mitra: state.selMitra,
                  )
                else
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: RegularText(
                      text: 'You haven\'t selected your freshMitra yet!',
                      color: AppTheme.black7,
                      fontSize: AppTheme.smallTextSize,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
