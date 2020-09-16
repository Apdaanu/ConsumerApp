import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/mitra_bloc/mitra_bloc.dart';

import '../../../../../core/constants/measure.dart';
import '../../../../../core/constants/routes.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../widgets/regular_text.dart';

class HomeSearchSection extends StatefulWidget {
  const HomeSearchSection({Key key}) : super(key: key);

  @override
  _HomeSearchSectionState createState() => _HomeSearchSectionState();
}

class _HomeSearchSectionState extends State<HomeSearchSection> {
  MitraBloc _mitraBloc;

  @override
  void initState() {
    super.initState();
    _mitraBloc = context.bloc();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Stack(
      children: <Widget>[
        Container(
          height: 35 + measure.width * 0.1,
          padding: EdgeInsets.only(
            left: measure.width * 0.04,
            right: measure.width * 0.04,
            top: measure.screenHeight * 0.01,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: measure.width * 0.75,
                height: measure.width * 0.1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, homeSearchRoute);
                  },
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: measure.width * 0.02),
                      Icon(
                        Icons.search,
                        color: AppTheme.black7,
                        size: 16 * measure.fontRatio,
                      ),
                      SizedBox(width: measure.width * 0.02),
                      RegularText(
                        text: "Search fruits, vegetables, recepies...",
                        color: AppTheme.black7,
                        fontSize: AppTheme.regularTextSize,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(selectMitraRoute);
                },
                child: Container(
                  width: measure.width * 0.1,
                  height: measure.width * 0.1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.record_voice_over,
                        color: AppTheme.homeBlue,
                      ),
                      RegularText(
                        text: "MITRA",
                        color: Colors.grey,
                        fontSize: 6,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        BlocBuilder(
          cubit: _mitraBloc,
          builder: (context, state) {
            if (_mitraBloc.selMitra == null || !_mitraBloc.selMitra.active) {
              return Positioned(
                right: measure.width * 0.04 - 7,
                top: measure.screenHeight * 0.01 - 7,
                child: Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.priority_high,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              );
            }
            return Container();
          },
        )
      ],
    );
  }
}
