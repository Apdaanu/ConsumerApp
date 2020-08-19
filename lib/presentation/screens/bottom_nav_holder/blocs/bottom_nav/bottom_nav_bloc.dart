import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

// part 'bottom_nav_event.dart';
part 'bottom_nav_state.dart';

class BottomNavBloc extends Bloc<int, int> {
  BottomNavBloc() : super(0);

  PageController pageController = PageController();

  @override
  Stream<int> mapEventToState(
    int event,
  ) async* {
    pageController.jumpToPage(
      event,
      // duration: const Duration(milliseconds: 500),
      // curve: Curves.easeIn,
    );
    yield event;
  }
}
