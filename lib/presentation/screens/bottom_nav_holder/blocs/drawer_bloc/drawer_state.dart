part of 'drawer_bloc.dart';

abstract class DrawerState extends Equatable {
  const DrawerState();
}

class DrawerInitial extends DrawerState {
  @override
  List<Object> get props => [];
}
