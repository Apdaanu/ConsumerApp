import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'select_place_event.dart';
part 'select_place_state.dart';

class SelectPlaceBloc extends Bloc<SelectPlaceEvent, SelectPlaceState> {
  SelectPlaceBloc() : super(SelectPlaceInitial());

  List searchRes;
  List list;

  @override
  Stream<SelectPlaceState> mapEventToState(
    SelectPlaceEvent event,
  ) async* {
    if (event is SelectPlaceInit) {
      this.searchRes = event.list;
      this.list = event.list;
      yield SelectPlaceLoaded();
    }

    if (event is SelectPlaceSearch) {
      yield SelectPlaceInitial();
      final List res = this
          .list
          .where((element) =>
              element.name.toLowerCase().indexOf(event.search.toLowerCase()) !=
              -1)
          .toList();
      this.searchRes = res;
      yield SelectPlaceLoaded();
    }
  }
}
