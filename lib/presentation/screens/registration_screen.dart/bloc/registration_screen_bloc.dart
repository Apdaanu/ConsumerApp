import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../domain/usecases/places/get_places.dart';
import '../../../../domain/usecases/registerUser/register_user.dart';
import '../../../../domain/usecases/services/dynamic_link_service.dart';

part 'registration_screen_event.dart';
part 'registration_screen_state.dart';

class RegistrationScreenBloc extends Bloc<RegistrationScreenEvent, RegistrationScreenState> {
  final RegisterUser registerUser;
  final ActivateReferral activateReferral;
  final GetPlaces getPlaces;
  final SharedPreferences sharedPreferences;

  RegistrationScreenBloc({
    @required this.registerUser,
    @required this.getPlaces,
    @required this.activateReferral,
    @required this.sharedPreferences,
  }) : super(null);

  List<dynamic> places;
  String cityId;
  TextEditingController referralController = TextEditingController();

  @override
  Stream<RegistrationScreenState> mapEventToState(
    RegistrationScreenEvent event,
  ) async* {
    if (event is RegisterUserInitEvent) {
      yield RegisterUserLoading();
      this.referralController.text = sharedPreferences.getString(REFERRAL_CACHE) ?? '';
      final failureOrPlaces = await getPlaces(NoParams());
      yield* failureOrPlaces.fold(
        (l) => null,
        (places) async* {
          print('[sys] : Places fetched');
          this.places = places;
          yield RegisterUserLoaded(places);
        },
      );
    }

    if (event is RegisterUserDoneReferral) {
      yield RegisterUserFilledReferral();
      await Future.delayed(Duration(milliseconds: 100));
      yield RegisterUserLoaded(places);
    }

    if (event is RegisterUserSelectCityEvent) {
      this.cityId = event.cityId;
      List<dynamic> areas = places[places.indexWhere((element) => element.id == event.cityId)].areas;
      yield RegisterUserCitySelected(areas);
    }

    if (event is RegisterUserGoBackEvent) {
      yield RegisterUserGoBack();
      await Future.delayed(const Duration(milliseconds: 200), () {});
      yield RegisterUserLoaded(places);
    }

    if (event is RegisterUserSelectAreaEvent) {
      print('[sys] : User registration requested');
      final failureOrUserDetails = await registerUser(RegisterUserParams(
        name: "freshOk user",
        cityId: this.cityId,
        areaId: event.areaId,
      ));
      yield* failureOrUserDetails.fold(
        (failure) async* {
          print('[err] : Failed to register: ${failure.code}');
        },
        (userDetails) async* {
          print('[sys] : User successfully registered');
          print('[sys] : Activating referral Code');
          activateReferral(
            ActivateReferralParams(
              referralCode: referralController.text,
              userId: userDetails.userId,
            ),
          );
          yield UserRegisteredState();
        },
      );
    }
  }
}
