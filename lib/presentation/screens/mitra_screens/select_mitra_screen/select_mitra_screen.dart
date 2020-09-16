import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';

import '../../../widgets/display_screen.dart';
import '../../../widgets/top_bar.dart';
import '../../bottom_nav_holder/blocs/mitra_bloc/mitra_bloc.dart';
import '../../bottom_nav_holder/blocs/user_details_bloc/user_details_bloc.dart';
import 'widgets/select_mitra_my_mitra_section.dart';
import 'widgets/select_mitra_options.dart';

GlobalKey selectMitraKey = GlobalKey();

class SelectMitraScreen extends StatefulWidget {
  @override
  _SelectMitraScreenState createState() => _SelectMitraScreenState();
}

class _SelectMitraScreenState extends State<SelectMitraScreen> {
  MitraBloc _mitraBloc;
  UserDetailsBloc _userDetailsBloc;

  @override
  void initState() {
    super.initState();
    _mitraBloc = context.bloc<MitraBloc>();
    _userDetailsBloc = context.bloc<UserDetailsBloc>();

    // _mitraBloc.add(MitraInitEvent(
    //   mitraId: _userDetailsBloc.userDetails.mitraId,
    //   userId: _userDetailsBloc.userDetails.userId,
    // ));
  }

  @override
  Widget build(BuildContext context) {
    return DisplayScreen(
      key: selectMitraKey,
      topBar: CustomTopBar(
        title: "My freshMitra",
        // action: RegularText(
        //   text: "SAVE",
        //   color: Colors.white,
        //   fontSize: AppTheme.smallTextSize,
        //   fontWeight: FontWeight.w700,
        // ),
      ),
      body: BlocListener(
        cubit: _mitraBloc,
        listener: (context, state) {
          if (state is MitraLoaded) {
            if (state.mitraChanged == true) {
              print('[dbg] : changing userdetails cache');
              _userDetailsBloc.add(
                UserDetailsChangeMitra(state.selMitra.mitraId),
              );
            }
          }
        },
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              BlocBuilder(
                cubit: _mitraBloc,
                builder: (context, state) {
                  if (_mitraBloc.selMitra != null && !_mitraBloc.selMitra.active)
                    return Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      alignment: Alignment.bottomCenter,
                      child: RegularText(
                        text:
                            'Your mitra is currently unavailable, please select another mitra to continue the fresh experience.',
                        color: AppTheme.black7,
                        fontSize: AppTheme.smallTextSize,
                        overflow: false,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.center,
                      ),
                    );
                  return Container();
                },
              ),
              SelectMitraMyMitraSection(),
              SelectMitraOptions(),
            ],
          ),
        ),
      ),
      failure: false,
      failureCode: 0,
    );
  }
}
