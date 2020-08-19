import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// part 'pop_address_event.dart';
// part 'pop_address_state.dart';

enum PopAddressEvent {
  show,
  hide,
}

class PopAddressBloc extends Bloc<PopAddressEvent, bool> {
  PopAddressBloc() : super(false);

  bool show = false;

  @override
  Stream<bool> mapEventToState(
    PopAddressEvent event,
  ) async* {
    switch (event) {
      case PopAddressEvent.show:
        this.show = true;
        yield true;
        break;
      case PopAddressEvent.hide:
        this.show = false;
        yield false;
        break;
      default:
        addError(Exception('unsupported event'));
    }
  }
}
