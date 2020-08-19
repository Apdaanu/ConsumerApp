part of 'home_section_bloc.dart';

abstract class HomeSectionEvent extends Equatable {
  const HomeSectionEvent();
}

class HomeSectionInitEvent extends HomeSectionEvent {
  @override
  List<Object> get props => [];
}
