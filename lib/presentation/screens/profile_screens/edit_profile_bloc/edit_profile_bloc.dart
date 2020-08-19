import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/domain/entities/user_details.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(EditProfileInitial());

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController areaController = TextEditingController();

  String cityId;
  String areaId;

  UserDetails userDetails;
  List places;

  @override
  Stream<EditProfileState> mapEventToState(
    EditProfileEvent event,
  ) async* {
    if (event is EditProfileInitEvent) {
      this.userDetails = event.userDetails;
      this.places = event.places;

      nameController.text = this.userDetails.name;
      addressController.text = this.userDetails.address;
      landmarkController.text = this.userDetails.landmark;
      pinController.text = this.userDetails.pin;
      this.cityId = this.userDetails.cityId;
      this.areaId = this.userDetails.areaId;
      areaController.text = this.userDetails.area;
      cityController.text = this.userDetails.city;
    }

    if (event is RegisterChange) {
      yield EditProfileChanged();
    }
  }
}
