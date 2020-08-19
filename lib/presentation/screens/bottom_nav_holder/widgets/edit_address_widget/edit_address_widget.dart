import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/home_section/home_section_bloc.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/pop_address_bloc/pop_address_bloc.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/recepie_home_bloc/recepie_home_bloc.dart';

import '../../../../../core/constants/routes.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/regular_text.dart';
import '../../../../widgets/text_field_underline.dart';
import '../../blocs/edit_address_bloc/edit_address_bloc.dart';
import '../../blocs/place_bloc/place_bloc.dart';
import '../../blocs/user_details_bloc/user_details_bloc.dart';

class EditAddressWidget extends StatefulWidget {
  @override
  _EditAddressWidgetState createState() => _EditAddressWidgetState();
}

class _EditAddressWidgetState extends State<EditAddressWidget> {
  EditAddressBloc _editAddressBloc;
  PlaceBloc _placeBloc;
  UserDetailsBloc _userDetailsBloc;
  HomeSectionBloc _homeSectionBloc;
  RecepieHomeBloc _recepieHomeBloc;
  PopAddressBloc _popAddressBloc;

  @override
  void initState() {
    super.initState();
    _userDetailsBloc = context.bloc<UserDetailsBloc>();
    _editAddressBloc = context.bloc<EditAddressBloc>();
    _homeSectionBloc = context.bloc<HomeSectionBloc>();
    _recepieHomeBloc = context.bloc<RecepieHomeBloc>();
    _popAddressBloc = context.bloc<PopAddressBloc>();

    _placeBloc = context.bloc<PlaceBloc>();

    _placeBloc.add(PlaceInitEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _userDetailsBloc,
      builder: (context, state) {
        return Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              EditAddressWidgetSection(
                hintText: "Full Name",
                title: "Name",
                controller: _editAddressBloc.nameController,
                focusNode: _editAddressBloc.nameFocus,
              ),
              SizedBox(height: 10),
              EditAddressWidgetSection(
                hintText: "H No. / Flat No. / Street / Block",
                title: "Address Line",
                controller: _editAddressBloc.addressController,
                focusNode: _editAddressBloc.addressFocus,
              ),
              SizedBox(height: 10),
              BlocBuilder(
                cubit: _placeBloc,
                builder: (context, state) => Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            selectCityAreaRoute,
                            arguments: {
                              'list': state is PlaceLoaded ? state.places : [],
                              'loading': state is PlaceLoaded ? false : true,
                              'title': 'Select City',
                              'ddFxn': (cityId) {
                                _editAddressBloc.add(
                                  EditAddressCityEvent(
                                    cityId,
                                    _placeBloc.places,
                                  ),
                                );
                              }
                            },
                          );
                        },
                        child: EditAddressWidgetSection(
                          hintText: "Select City",
                          title: "City",
                          enabled: false,
                          controller: _editAddressBloc.cityController,
                        ),
                      ),
                    ),
                    // SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            selectCityAreaRoute,
                            arguments: {
                              'list': state is PlaceLoaded
                                  ? state
                                      .places[state.places.indexWhere(
                                          (element) =>
                                              element.id ==
                                              _userDetailsBloc
                                                  .userDetails.cityId)]
                                      .areas
                                  : [],
                              'loading': state is PlaceLoaded ? false : true,
                              'title': 'Select Area/Society',
                              'ddFxn': (areaId) {
                                _editAddressBloc.add(
                                  EditAddressAreaEvent(
                                    areaId,
                                    _placeBloc.places,
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            },
                          );
                        },
                        child: EditAddressWidgetSection(
                          hintText: "Select Area/Society",
                          title: "Area/Society",
                          enabled: false,
                          controller: _editAddressBloc.areaController,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              BlocBuilder(
                cubit: _userDetailsBloc,
                builder: (context, state) => CustomButton(
                  height: 50,
                  width: null,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    _userDetailsBloc.add(
                      UserDetailsEditEvent(
                          address: _editAddressBloc.addressController.text,
                          areaId: _editAddressBloc.areaId,
                          cityId: _editAddressBloc.cityId,
                          landmark: _userDetailsBloc.userDetails.landmark,
                          name: _editAddressBloc.nameController.text,
                          pin: _userDetailsBloc.userDetails.pin,
                          next: (userId) {
                            _popAddressBloc.add(PopAddressEvent.hide);
                            _homeSectionBloc.add(HomeSectionInitEvent());
                            _recepieHomeBloc.add(RecepieHomeInit(userId));
                          }),
                    );
                  },
                  color: _userDetailsBloc.updating
                      ? Colors.grey[100]
                      : AppTheme.primaryColor,
                  child: Center(
                    child: !_userDetailsBloc.updating
                        ? RegularText(
                            text: "Save",
                            color: Colors.white,
                            fontSize: AppTheme.regularTextSize,
                          )
                        : SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryColor),
                              strokeWidth: 2,
                            ),
                          ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class EditAddressWidgetSection extends StatelessWidget {
  final String title;
  final String hintText;
  final bool enabled;
  final TextEditingController controller;
  final FocusNode focusNode;

  const EditAddressWidgetSection({
    Key key,
    @required this.title,
    @required this.hintText,
    this.enabled,
    this.controller,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //total height: 90
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 30,
            child: Align(
              alignment: Alignment.centerLeft,
              child: RegularText(
                text: title,
                color: AppTheme.black5,
                fontSize: AppTheme.extraSmallTextSize,
              ),
            ),
          ),
          Container(
            height: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.greyF5,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: CustomTextFieldUnderline(
                    hintText: hintText,
                    underlineHeight: 0,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    enabled: enabled,
                    controller: controller,
                    focusNode: focusNode,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
