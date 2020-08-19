part of 'home_section_bloc.dart';

abstract class HomeSectionState extends Equatable {
  const HomeSectionState();
}

class HomeSectionInitial extends HomeSectionState {
  @override
  List<Object> get props => [];
}

class HomeSectionLoading extends HomeSectionState {
  @override
  List<Object> get props => [];
}

class HomeSectionLoaded extends HomeSectionState {
  final List sections;

  HomeSectionLoaded(this.sections);

  @override
  List<Object> get props => [sections];
}
