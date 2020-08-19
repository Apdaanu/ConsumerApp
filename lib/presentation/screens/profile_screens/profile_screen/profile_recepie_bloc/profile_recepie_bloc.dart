import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:freshOk/domain/entities/categories/recepie.dart';

import '../../../../../domain/usecases/categories/get_liked_recepies.dart';
import '../../../../../domain/usecases/categories/get_my_recepies.dart';
import '../../../../../domain/usecases/categories/like_recepie.dart';

part 'profile_recepie_event.dart';
part 'profile_recepie_state.dart';

class ProfileRecepieBloc
    extends Bloc<ProfileRecepieEvent, ProfileRecepieState> {
  final GetMyRecepies getMyRecepies;
  final GetLikedRecepies getLikedRecepies;
  final LikeRecepie likeRecepie;

  ProfileRecepieBloc({
    @required this.getMyRecepies,
    @required this.getLikedRecepies,
    @required this.likeRecepie,
  }) : super(ProfileRecepieInitial());

  List myRecepies = List();
  bool loadedMyRecepies = false;
  int tabIndex = 0;

  List likedRecepies = List();
  bool loadedLiked = false;

  String userId;

  @override
  Stream<ProfileRecepieState> mapEventToState(
    ProfileRecepieEvent event,
  ) async* {
    if (event is ProfileRecepieLoadMyRecepies) {
      if (!loadedMyRecepies) {
        print('[sys] : fetching my recepies');
        final failureOrRecepies = await getMyRecepies(
          GetMyRecepiesParams(event.userId),
        );

        yield* failureOrRecepies.fold(
          (failure) async* {
            print('[err] : failed to get my recepies : ${failure.code}');
          },
          (list) async* {
            print('[sys] : My Recepies fetched');
            this.myRecepies = list;
            this.loadedMyRecepies = true;
            this.userId = event.userId;
            yield ProfileRecepieLoaded();
          },
        );
      } else {
        yield ProfileRecepieLoaded();
      }
    }

    if (event is ProfileRecepieLoadLiked) {
      if (!loadedLiked) {
        print('[sys] : fetching liked recepies');
        final failureOrRecepies = await getLikedRecepies(
          GetLikedRecepiesParams(event.userId),
        );

        yield* failureOrRecepies.fold(
          (failure) async* {
            print('[err] : failed to get liked recepies : ${failure.code}');
          },
          (list) async* {
            print('[sys] : liked Recepies fetched');
            this.likedRecepies = list;
            this.loadedLiked = true;
            this.userId = event.userId;
            yield ProfileRecepieLoaded();
          },
        );
      } else {
        yield ProfileRecepieLoaded();
      }
    }

    if (event is ProfileRecepieToggleCat) {
      yield ProfileRecepieInitial();
      this.tabIndex = event.index;
      yield ProfileRecepieLoaded();
    }

    if (event is ProfileRecepieLike) {
      yield ProfileRecepieInitial();
      _handleToggleLike(event.recepieId);
      yield ProfileRecepieLoaded();

      final failureOrSuccess = await likeRecepie(
        LikeRecepieParams(
          recepieId: event.recepieId,
          userId: this.userId,
        ),
      );

      failureOrSuccess.fold(
        (failure) {
          print('[err] : failed to like the recepie');
          likeRecepie(
            LikeRecepieParams(
              recepieId: event.recepieId,
              userId: this.userId,
            ),
          );
        },
        (success) {},
      );
    }

    if (event is ProfileRecepieLikeAction) {
      yield ProfileRecepieInitial();
      _handleToggleLike(event.recepieId);
      yield ProfileRecepieLoaded();
    }
  }

  void _handleToggleLike(recepieId) {
    if (tabIndex == 0) {
      List likes = this
          .likedRecepies[this
              .likedRecepies
              .indexWhere((element) => element.id == recepieId)]
          .likes;
      if (likes.indexOf(this.userId) == -1) {
        this
            .likedRecepies[this
                .likedRecepies
                .indexWhere((element) => element.id == recepieId)]
            .likes
            .add(this.userId);
      } else {
        this
            .likedRecepies[this
                .likedRecepies
                .indexWhere((element) => element.id == recepieId)]
            .likes
            .remove(this.userId);
      }
    } else {
      List likes = this
          .myRecepies[
              this.myRecepies.indexWhere((element) => element.id == recepieId)]
          .likes;
      if (likes.indexOf(this.userId) == -1) {
        this
            .myRecepies[this
                .myRecepies
                .indexWhere((element) => element.id == recepieId)]
            .likes
            .add(this.userId);
      } else {
        this
            .myRecepies[this
                .myRecepies
                .indexWhere((element) => element.id == recepieId)]
            .likes
            .remove(this.userId);
      }
    }
  }
}
