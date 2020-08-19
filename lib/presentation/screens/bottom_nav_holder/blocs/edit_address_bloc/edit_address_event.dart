part of 'edit_address_bloc.dart';

abstract class EditAddressEvent extends Equatable {
  const EditAddressEvent();
}

class EditAddressInitEvent extends EditAddressEvent {
  final UserDetails userDetails;

  EditAddressInitEvent(this.userDetails);

  @override
  List<Object> get props => [userDetails];
}

class EditAddressCityEvent extends EditAddressEvent {
  final String cityId;
  final List places;

  EditAddressCityEvent(this.cityId, this.places);

  @override
  List<Object> get props => [cityId, places];
}

class EditAddressAreaEvent extends EditAddressEvent {
  final String areaId;
  final List places;

  EditAddressAreaEvent(this.areaId, this.places);

  @override
  List<Object> get props => [areaId, places];
}
