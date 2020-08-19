import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/usecases/categories/get_cuisines.dart';

import '../../../../../domain/usecases/categories/get_dish_types.dart';

part 'create_recepie_event.dart';
part 'create_recepie_state.dart';

class CreateRecepieBloc extends Bloc<CreateRecepieEvent, CreateRecepieState> {
  final GetDishTypes getDishTypes;
  final GetCuisines getCuisines;

  CreateRecepieBloc({
    @required this.getDishTypes,
    @required this.getCuisines,
  }) : super(CreateRecepieInitial());

  int totalSteps = 4;
  int step = 0;

  PageController controller = PageController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController ytLinkController = TextEditingController();

  FocusNode titleNode = FocusNode();
  FocusNode descNode = FocusNode();

  List dishTypes;
  bool dishTypeLoaded = false;
  List selDishes = List();

  List cuisines;
  bool cuisinesLoaded = false;
  List selCuisines = List();

  List ingridients = List();

  @override
  Stream<CreateRecepieState> mapEventToState(
    CreateRecepieEvent event,
  ) async* {
    if (event is CreateRecepieNext) {
      if (step < totalSteps - 1) {
        if (step == 0) {
          if (titleController.text == '') {
            titleNode.requestFocus();
            return;
          }
          if (descController.text == '') {
            descNode.requestFocus();
            return;
          }
        }

        if (step == 2) {
          if (ingridients.length == 0) return;
        }

        yield CreateRecepieInitial();
        controller.animateToPage(
          step + 1,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
        this.step++;
        yield CreateRecepieLoaded();
      }
    }

    if (event is CreateRecepieBack) {
      if (step > 0) {
        yield CreateRecepieInitial();
        controller.animateToPage(
          step - 1,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
        this.step--;
        yield CreateRecepieLoaded();
      }
    }

    if (event is RefreshEvent) {
      yield CreateRecepieInitial();
      yield CreateRecepieLoaded();
    }

    if (event is CreateRecepieGetDishes) {
      if (!dishTypeLoaded) {
        final failureOrDishes = await getDishTypes(NoParams());

        yield* failureOrDishes.fold(
          (failure) async* {
            print('[err] : failed to get dish types');
          },
          (dishes) async* {
            print('[sys] : dish types fetched');
            yield CreateRecepieInitial();
            this.dishTypes = dishes;
            this.dishTypeLoaded = true;
            yield CreateRecepieLoaded();
          },
        );
      }
    }

    if (event is CreateRecepieGetCuisines) {
      if (!cuisinesLoaded) {
        final failureOrDishes = await getCuisines(NoParams());

        yield* failureOrDishes.fold(
          (failure) async* {
            print('[err] : failed to get dish cuisines');
          },
          (cuisines) async* {
            print('[sys] : cuisines fetched');
            yield CreateRecepieInitial();
            this.cuisines = cuisines;
            this.cuisinesLoaded = true;
            yield CreateRecepieLoaded();
          },
        );
      }
    }

    if (event is CreateRecepieSelDish) {
      yield CreateRecepieInitial();
      if (this.selDishes.indexOf(event.id) == -1) {
        this.selDishes.add(event.id);
      } else {
        this.selDishes.remove(event.id);
      }
      yield CreateRecepieLoaded();
    }

    if (event is CreateRecepieSelCuisines) {
      yield CreateRecepieInitial();
      if (this.selCuisines.indexOf(event.id) == -1) {
        this.selCuisines.add(event.id);
      } else {
        this.selCuisines.remove(event.id);
      }
      yield CreateRecepieLoaded();
    }

    if (event is CreateRecepieAddIngridient) {
      yield CreateRecepieInitial();
      var ingridient = {
        'type': event.type,
        'value': event.value,
        'quantity': event.quantity,
      };

      this.ingridients.add(ingridient);

      yield CreateRecepieLoaded();
    }

    if (event is CreateRecepieEditIngridient) {
      if (event.index != null) {
        yield CreateRecepieInitial();
        this.ingridients[event.index] = {
          'type': event.type,
          'value': event.value,
          'quantity': event.quantity,
        };

        yield CreateRecepieLoaded();
      }
    }
  }
}
