import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/constants/routes.dart';
import 'package:freshOk/core/theme/theme.dart';
import 'package:freshOk/presentation/screens/bottom_nav_holder/blocs/user_details_bloc/user_details_bloc.dart';
import 'package:freshOk/presentation/screens/profile_screens/widgets/profile_photo_widget.dart';
import 'package:freshOk/presentation/widgets/custom_button.dart';
import 'package:freshOk/presentation/widgets/regular_text.dart';

class ProfileInfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    final double profileImageHeight = 100 + measure.width * 0.05;
    UserDetailsBloc _userDetailsBloc = context.bloc<UserDetailsBloc>();

    return BlocBuilder(
      cubit: _userDetailsBloc,
      builder: (context, state) {
        if (state is LoadedUserState) {
          return Container(
            padding:
                EdgeInsets.symmetric(horizontal: 10 + measure.width * 0.02),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ProfilePhotoWidget(
                  size: profileImageHeight,
                ),
                SizedBox(width: 10 + measure.width * 0.02),
                SizedBox(
                  height: profileImageHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RegularText(
                        text: state.userDetails.name,
                        color: AppTheme.black3,
                        fontSize: AppTheme.headingTextSize,
                        fontWeight: FontWeight.w700,
                      ),
                      RegularText(
                        text: _userDetailsBloc.basicUser.mob.toString(),
                        color: AppTheme.black5,
                        fontSize: AppTheme.regularTextSize,
                      ),
                      Expanded(child: Container()),
                      SizedBox(
                        width: measure.width * 0.55,
                        child: RegularText(
                          text: state.userDetails.address == null ||
                                  state.userDetails.address.length == 0
                              ? 'unnamed road'
                              : state.userDetails.address,
                          color: AppTheme.black3,
                          fontSize: AppTheme.smallTextSize,
                          maxLines: 1,
                        ),
                      ),
                      RegularText(
                        text: state.userDetails.area +
                            ', ' +
                            state.userDetails.city,
                        color: AppTheme.black3,
                        fontSize: AppTheme.smallTextSize,
                      ),
                      SizedBox(height: 10),
                      CustomButton(
                        height: null,
                        width: null,
                        onTap: () {
                          Navigator.pushNamed(context, editProfileRoute);
                        },
                        color: Colors.white,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.5, color: AppTheme.primaryColor),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          alignment: Alignment.center,
                          child: RegularText(
                            text: "Edit Profile",
                            color: AppTheme.primaryColor,
                            fontSize: AppTheme.smallTextSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
