import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/mitra_bloc/mitra_bloc.dart';
import 'package:freshOk/presentation/widgets/card_shimmer.dart';
import 'package:freshOk/presentation/widgets/loader.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';

import 'select_mitra_card.dart';

class SelectMitraOptions extends StatefulWidget {
  const SelectMitraOptions({Key key}) : super(key: key);

  @override
  _SelectMitraOptionsState createState() => _SelectMitraOptionsState();
}

class _SelectMitraOptionsState extends State<SelectMitraOptions> {
  MitraBloc _mitraBloc;

  @override
  void initState() {
    super.initState();
    _mitraBloc = context.bloc<MitraBloc>();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      width: measure.width,
      height: measure.bodyHeight - 140,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10 + measure.width * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 30),
              RegularText(
                text: "Available",
                color: AppTheme.black7,
                fontSize: AppTheme.extraSmallTextSize,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 10),
              BlocBuilder(
                cubit: _mitraBloc,
                builder: (context, state) {
                  if (state is MitraLoading) {
                    return Column(
                      children: List.generate(
                        5,
                        (index) {
                          return CardShimmer(lag: index * 10);
                        },
                      ),
                    );
                  }
                  if (state is MitraLoaded) {
                    return Column(
                      children: _renderMitras(
                        state.mitras,
                        state.selMitra != null ? state.selMitra.mitraId : '',
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _renderMitras(List mitras, String selMitaId) {
    List<Widget> list = List<Widget>();
    mitras.forEach((element) {
      list.add(SelectMitraCard(
        mitra: element,
        onTap: (mitra) {
          _mitraBloc.add(MitraSelectEvent(mitra));
        },
        bgColor: element.mitraId == selMitaId ? AppTheme.cartOrange : null,
        textColor: element.mitraId == selMitaId ? Colors.white : null,
      ));
      list.add(SizedBox(height: 15));
    });
    return list;
  }
}
