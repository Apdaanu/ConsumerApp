import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/usecases/places/get_places.dart';

part 'place_event.dart';
part 'place_state.dart';

class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
  final GetPlaces getPlaces;

  PlaceBloc(this.getPlaces) : super(PlaceInitial());

  List places = List();
  bool placesLoaded = false;

  @override
  Stream<PlaceState> mapEventToState(
    PlaceEvent event,
  ) async* {
    if (event is PlaceInitEvent) {
      if (!placesLoaded) {
        yield PlaceLoading();
        print('[sys] : fetching places');
        final failureOrPlaces = await getPlaces(NoParams());
        yield* failureOrPlaces.fold(
          (failure) async* {
            print('[err] : fetching places failed ${failure.code}');
          },
          (places) async* {
            print('[sys] : places fetched');
            this.places = places;
            this.placesLoaded = true;
            yield PlaceLoaded(places);
          },
        );
      } else {
        yield PlaceLoaded(this.places);
      }
      if (event.next != null) {
        event.next();
      }
    }
  }
}
