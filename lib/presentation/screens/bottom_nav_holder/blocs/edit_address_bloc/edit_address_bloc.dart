import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/entities/user_details.dart';

part 'edit_address_event.dart';
part 'edit_address_state.dart';

class EditAddressBloc extends Bloc<EditAddressEvent, EditAddressState> {
  EditAddressBloc() : super(EditAddressInitial());

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController areaController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode addressFocus = FocusNode();

  String areaId;
  String cityId;

  @override
  Stream<EditAddressState> mapEventToState(
    EditAddressEvent event,
  ) async* {
    if (event is EditAddressInitEvent) {
      nameFocus.unfocus();
      addressFocus.unfocus();

      nameController.text = event.userDetails.name ?? '';
      addressController.text = event.userDetails.address ?? '';
      areaController.text = event.userDetails.area;
      cityController.text = event.userDetails.city;
      this.areaId = event.userDetails.areaId;
      this.cityId = event.userDetails.cityId;
    }

    if (event is EditAddressCityEvent) {}

    if (event is EditAddressAreaEvent) {
      this.areaId = event.areaId;
      List areas = event
          .places[event.places.indexWhere((element) => element.id == cityId)]
          .areas;
      areaController.text =
          areas[areas.indexWhere((element) => element.id == this.areaId)].name;
    }
  }
}
