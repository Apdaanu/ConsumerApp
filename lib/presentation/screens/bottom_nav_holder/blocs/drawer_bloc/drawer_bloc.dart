import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/usecases/logout/logout_user.dart';

part 'drawer_event.dart';
part 'drawer_state.dart';

class DrawerBloc extends Bloc<DrawerEvent, DrawerState> {
  final LogoutUser logoutUser;

  DrawerBloc(this.logoutUser) : super(DrawerInitial());

  @override
  Stream<DrawerState> mapEventToState(
    DrawerEvent event,
  ) async* {
    if (event is LogoutEvent) {
      print('[sys] : Logging user out');
      await logoutUser(NoParams());
    }
  }
}
