part of 'drawer_bloc.dart';

abstract class DrawerEvent extends Equatable {
  const DrawerEvent();
}

class LogoutEvent extends DrawerEvent {
  @override
  List<Object> get props => [];
}
