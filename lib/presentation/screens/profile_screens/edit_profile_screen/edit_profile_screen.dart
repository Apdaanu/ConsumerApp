import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/measure.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../injection_container.dart';
import '../../../widgets/display_screen.dart';
import '../../../widgets/regular_text.dart';
import '../../../widgets/text_field_underline.dart';
import '../../../widgets/top_bar.dart';
import '../../bottom_nav_holder/blocs/place_bloc/place_bloc.dart';
import '../../bottom_nav_holder/blocs/user_details_bloc/user_details_bloc.dart';
import '../edit_profile_bloc/edit_profile_bloc.dart';
import '../widgets/profile_photo_widget.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  UserDetailsBloc _userDetailsBloc;
  EditProfileBloc _editProfileBloc;
  PlaceBloc _placeBloc;

  @override
  void initState() {
    super.initState();
    _userDetailsBloc = context.bloc<UserDetailsBloc>();
    _placeBloc = context.bloc<PlaceBloc>();
    _editProfileBloc = sl<EditProfileBloc>();

    _placeBloc.add(PlaceInitEvent(
      next: () {
        _editProfileBloc.add(
          EditProfileInitEvent(
              userDetails: _userDetailsBloc.userDetails,
              places: _placeBloc.places),
        );
      },
    ));

    _editProfileBloc.phoneController.text =
        _userDetailsBloc.basicUser.mob.toString();
  }

  @override
  void dispose() {
    _editProfileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return DisplayScreen(
      topBar: Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                blurRadius: 2,
                offset: Offset(0, 1),
                color: Color(0x29000000),
              )
            ],
          ),
          child: BlocBuilder(
            cubit: _userDetailsBloc,
            builder: (context, state) => CustomTopBar(
              title: "Edit Profile",
              lightTheme: true,
              action: GestureDetector(
                onTap: () {
                  if (!_userDetailsBloc.updating) {
                    _userDetailsBloc.add(
                      UserDetailsEditEvent(
                        address: _editProfileBloc.addressController.text,
                        cityId: _editProfileBloc.cityId,
                        areaId: _editProfileBloc.areaId,
                        landmark: _editProfileBloc.landmarkController.text,
                        pin: _editProfileBloc.pinController.text,
                        name: _editProfileBloc.nameController.text,
                      ),
                    );
                  }
                },
                child: Row(
                  children: <Widget>[
                    _userDetailsBloc.updating
                        ? SizedBox(
                            height: 12,
                            width: 12,
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryColor),
                              strokeWidth: 2,
                            ),
                          )
                        : Container(),
                    SizedBox(width: 10),
                    BlocBuilder(
                      cubit: _editProfileBloc,
                      builder: (context, state) {
                        if (state is EditProfileChanged) {
                          return RegularText(
                            text: "SAVE",
                            color: AppTheme.primaryColor,
                            fontSize: AppTheme.regularTextSize,
                            fontWeight: FontWeight.bold,
                          );
                        }
                        return Container();
                      },
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          )),
      body: Container(
        height: measure.bodyHeight,
        width: measure.width,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 10 + measure.width * 0.02),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20 + measure.screenHeight * 0.03),
                ProfilePhotoWidget(edit: true),
                SizedBox(height: 20 + measure.screenHeight * 0.03),
                EditProfileScreenInput(
                  hintText: 'John Doe',
                  title: 'Full Name',
                  controller: _editProfileBloc.nameController,
                  onChanged: _registerChange,
                ),
                SizedBox(height: 20 + measure.screenHeight * 0.03),
                EditProfileScreenInput(
                  hintText: '10 digit mobile number',
                  title: 'Phone Number',
                  enabled: false,
                  controller: _editProfileBloc.phoneController,
                  onChanged: _registerChange,
                ),
                SizedBox(height: 20 + measure.screenHeight * 0.03),
                EditProfileScreenInput(
                  hintText: 'H No. / Flat No. / Street / Block',
                  title: 'Address',
                  controller: _editProfileBloc.addressController,
                  maxLines: 2,
                  onChanged: _registerChange,
                ),
                SizedBox(height: 20 + measure.screenHeight * 0.03),
                BlocBuilder<PlaceBloc, PlaceState>(builder: (context, state) {
                  return Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              selectCityAreaRoute,
                              arguments: {
                                'list':
                                    state is PlaceLoaded ? state.places : [],
                                'loading': state is PlaceLoaded ? false : true,
                                'title': 'Select City',
                                'ddFxn': (cityId) {
                                  _editProfileBloc.cityId = cityId;
                                  _editProfileBloc.cityController.text =
                                      _placeBloc
                                          .places[_placeBloc.places.indexWhere(
                                              (element) =>
                                                  element.id == cityId)]
                                          .name;
                                  Navigator.pop(context);
                                },
                              },
                            );
                          },
                          child: EditProfileScreenInput(
                            hintText: 'Eg: Gurugram',
                            title: 'City',
                            enabled: false,
                            controller: _editProfileBloc.cityController,
                            onChanged: _registerChange,
                          ),
                        ),
                      ),
                      SizedBox(width: 15 + measure.width * 0.04),
                      Expanded(
                        flex: 1,
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
                                'title': 'Select Area',
                                'ddFxn': (areaId) {
                                  final areas = _placeBloc
                                      .places[_placeBloc.places.indexWhere(
                                          (element) =>
                                              element.id ==
                                              _editProfileBloc.cityId)]
                                      .areas;
                                  _editProfileBloc.areaController
                                      .text = areas[areas.indexWhere(
                                          (element) => element.id == areaId)]
                                      .name;
                                  _editProfileBloc.areaId = areaId;
                                  Navigator.pop(context);
                                },
                              },
                            );
                          },
                          child: EditProfileScreenInput(
                            hintText: 'Eg: Sec 104',
                            title: 'Area/Society',
                            enabled: false,
                            controller: _editProfileBloc.areaController,
                            onChanged: _registerChange,
                          ),
                        ),
                      )
                    ],
                  );
                }),
                SizedBox(height: 20 + measure.screenHeight * 0.03),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: EditProfileScreenInput(
                        hintText: 'Eg: Last House',
                        title: 'Landmark',
                        controller: _editProfileBloc.landmarkController,
                        onChanged: _registerChange,
                      ),
                    ),
                    SizedBox(width: 15 + measure.width * 0.04),
                    Expanded(
                      flex: 1,
                      child: EditProfileScreenInput(
                        hintText: 'Eg: 122201',
                        title: 'Pin',
                        controller: _editProfileBloc.pinController,
                        onChanged: _registerChange,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20 + measure.screenHeight * 0.03),
              ],
            ),
          ),
        ),
      ),
      failure: false,
      failureCode: 0,
    );
  }

  void _registerChange() {
    _editProfileBloc.add(RegisterChange());
  }
}

class EditProfileScreenInput extends StatelessWidget {
  final String title;
  final String hintText;
  final EdgeInsets margin;
  final bool enabled;
  final TextEditingController controller;
  final int maxLines;
  final onChanged;

  const EditProfileScreenInput({
    Key key,
    @required this.title,
    @required this.hintText,
    this.margin,
    this.enabled,
    this.controller,
    this.maxLines,
    this.onChanged,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: AppTheme.greyF5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: RegularText(
              text: title,
              color: AppTheme.black7,
              fontSize: AppTheme.extraSmallTextSize,
            ),
          ),
          CustomTextFieldUnderline(
            hintText: hintText,
            padding: EdgeInsets.symmetric(horizontal: 15),
            fontSize: AppTheme.headingTextSize,
            fontWeight: FontWeight.w500,
            enabled: enabled,
            controller: controller,
            maxLines: maxLines,
            color: Color(0xff828282),
            onChanged: (value) {
              onChanged();
            },
          ),
        ],
      ),
    );
  }
}
