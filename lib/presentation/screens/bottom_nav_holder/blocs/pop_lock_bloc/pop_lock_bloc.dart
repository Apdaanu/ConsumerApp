import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'pop_lock_event.dart';
part 'pop_lock_state.dart';

class PopLockBloc extends Bloc<PopLockEvent, PopLockState> {
  PopLockBloc() : super(PopLockInitial());

  bool lock = false;
  var next;

  @override
  Stream<PopLockState> mapEventToState(
    PopLockEvent event,
  ) async* {
    if (event is PopLockAcquire) {
      this.lock = true;
      this.next = event.next;
    }
    if (event is PopLockRelease) {
      this.lock = false;
      this.next();
    }
  }
}
