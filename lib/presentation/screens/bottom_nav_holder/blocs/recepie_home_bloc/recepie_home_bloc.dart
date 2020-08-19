import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freshOk/domain/usecases/categories/get_recepie_sections.dart';

part 'recepie_home_event.dart';
part 'recepie_home_state.dart';

class RecepieHomeBloc extends Bloc<RecepieHomeEvent, RecepieHomeState> {
  final GetRecepieSections getRecepieSections;

  RecepieHomeBloc(this.getRecepieSections) : super(RecepieHomeInitial());

  List sections;
  bool loaded = false;

  @override
  Stream<RecepieHomeState> mapEventToState(
    RecepieHomeEvent event,
  ) async* {
    if (event is RecepieHomeInit) {
      if (!loaded) {
        print('[sys] : fetching recepie sections');
        final failureOrSections = await getRecepieSections(
          GetSectionParams(event.userId),
        );

        yield* failureOrSections.fold(
          (failure) async* {
            print('[err] : failed to fetch recepie home sections');
          },
          (sections) async* {
            print('[sys] : recepie home sections fecthed');
            this.sections = sections;
            this.loaded = true;
            yield RecepieHomeLoaded();
          },
        );
      } else {
        yield RecepieHomeLoaded();
      }
    }
  }
}
