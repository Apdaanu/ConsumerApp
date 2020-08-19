import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../../../domain/entities/basic_user.dart';
import '../../../../../domain/entities/user_details.dart';
import '../../../../../domain/usecases/services/firebase_registration_service.dart';
import '../../../../../domain/usecases/services/image_service.dart';
import '../../../../../domain/usecases/user_details/get_basic_user.dart';
import '../../../../../domain/usecases/user_details/get_user_details.dart';
import '../../../../../domain/usecases/user_details/renew_user_details_cache.dart';
import '../../../../../domain/usecases/user_details/update_user_details.dart';

part 'user_details_event.dart';
part 'user_details_state.dart';

class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  final GetUserDetails getUserDetails;
  final RenewUserDetailsCache renewUserDetailsCache;
  final FirebaseRegistrationService fcmService;
  final GetBasicUser getBasicUser;
  final UpdateUserDetails updateUserDetails;
  final ImageService imageService;

  UserDetailsBloc({
    @required this.getUserDetails,
    @required this.renewUserDetailsCache,
    @required this.fcmService,
    @required this.getBasicUser,
    @required this.updateUserDetails,
    @required this.imageService,
  }) : super(null);

  UserDetails userDetails;
  BasicUser basicUser;
  bool updating = false;
  bool uploadingImage = false;

  @override
  Stream<UserDetailsState> mapEventToState(
    UserDetailsEvent event,
  ) async* {
    if (event is InitUserDetailsEvent) {
      yield LoadingUserState();

      final failureOrUserDetails = await getUserDetails(NoParams());
      yield* failureOrUserDetails.fold(
        (failure) async* {
          print('[err] : User details not found : ${failure.code}');
        },
        (userDetails) async* {
          print('[sys] : User found');
          this.userDetails = userDetails;
          event.next(userDetails.userId);
          yield LoadedUserState(userDetails);
        },
      );
      final failureOrBasicUser = await getBasicUser(NoParams());
      yield* failureOrBasicUser.fold(
        (failure) async* {
          print('[err] : basic user not found : ${failure.code}');
        },
        (basicUser) async* {
          print('[sys] : Basic User Found');
          this.basicUser = basicUser;
        },
      );

      print('[sys] : Posting fcm token');
      fcmService.postRegistrationToken(this.userDetails.userId);

      print('[sys] : renewing user details');
      final failureOrTrue = await renewUserDetailsCache(NoParams());
      yield* failureOrTrue.fold(
        (failure) async* {
          print('[err] : failed to renew user details cache :${failure.code}');
        },
        (res) async* {
          print('[sys] : user details renewed');
        },
      );
    }

    if (event is UserDetailsEditEvent) {
      yield LoadingUserState();
      this.updating = true;
      yield LoadedUserState(this.userDetails);
      print('[sys] : updating user details');
      final failureOrUserDetails = await updateUserDetails(
        UpdateDetailaParams(
          name: event.name,
          address: event.address,
          cityId: event.cityId,
          areaId: event.areaId,
          landmark: event.landmark,
          pin: event.pin,
          imageUrl: this.userDetails.profilePhoto,
        ),
      );
      yield* failureOrUserDetails.fold(
        (failure) async* {
          print('[err] : failed to update user details');
          yield LoadingUserState();
          this.updating = false;
          yield LoadedUserState(this.userDetails);
        },
        (userDetails) async* {
          print('[sys] : user details updated successfully');
          yield LoadingUserState();
          this.userDetails = userDetails;
          this.updating = false;
          yield LoadedUserState(userDetails);
          if (event.next != null) {
            event.next(userDetails.userId);
          }
        },
      );
    }

    if (event is UserDetailsChangeMitra) {
      yield LoadingUserState();
      this.userDetails.mitraId = event.mitraId;
      yield LoadedUserState(this.userDetails);

      print('[sys] : renewing user details');
      final failureOrTrue = await renewUserDetailsCache(NoParams());
      yield* failureOrTrue.fold(
        (failure) async* {
          print('[err] : failed to renew user details cache :${failure.code}');
        },
        (res) async* {
          print('[sys] : user details renewed');
        },
      );
    }

    if (event is UserDetailsChangePhoto) {
      final failureOrUrl = await imageService.uploadImage(
        fileName: 'freshOk_profile.jpg',
        file: event.file,
      );
      yield* failureOrUrl.fold(
        (l) async* {
          print('[dbg] : failed to upload image');
        },
        (url) async* {
          yield LoadingUserState();
          this.userDetails.profilePhoto = url;
          yield LoadedUserState(this.userDetails);

          final failureOrUserDetails = await updateUserDetails(
            UpdateDetailaParams(
              name: this.userDetails.name,
              address: this.userDetails.address,
              cityId: this.userDetails.cityId,
              areaId: this.userDetails.areaId,
              landmark: this.userDetails.landmark,
              pin: this.userDetails.pin,
              imageUrl: url,
            ),
          );
          yield* failureOrUserDetails.fold((failure) async* {
            print('[err] : failed to update user details');
          }, (userDetails) async* {
            print('[sys] : user details updated successfully');
            yield LoadingUserState();
            this.userDetails = userDetails;
            yield LoadedUserState(userDetails);
          });
        },
      );
    }
  }
}
