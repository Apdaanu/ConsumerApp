import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../domain/entities/categories/sub_category.dart';
import '../../../../../domain/usecases/categories/like_recepie.dart';

part 'recepie_home_card_event.dart';
part 'recepie_home_card_state.dart';

class RecepieHomeCardBloc
    extends Bloc<RecepieHomeCardEvent, RecepieHomeCardState> {
  final LikeRecepie likeRecepie;

  RecepieHomeCardBloc(this.likeRecepie) : super(RecepieHomeCardInitial());

  SubCategory recepie;
  bool isLiked = false;
  String userId;

  @override
  Stream<RecepieHomeCardState> mapEventToState(
    RecepieHomeCardEvent event,
  ) async* {
    if (event is CardBlocInit) {
      this.recepie = event.recepie;
      this.userId = event.userId;
      this.isLiked = recepie.likes.indexOf(event.userId) != -1 ? true : false;
      yield RecepieHomeCardLoaded();
    }

    if (event is CardLikeRecepie) {
      yield RecepieHomeCardInitial();
      if (!isLiked) {
        this.recepie.likes.add(this.userId);
      } else {
        this.recepie.likes.remove(this.userId);
      }
      this.isLiked = !this.isLiked;
      yield RecepieHomeCardLoaded();

      final failureOrSuccess = await likeRecepie(
        LikeRecepieParams(
          recepieId: this.recepie.value,
          userId: this.userId,
        ),
      );

      failureOrSuccess.fold(
        (failure) {
          print('[err] : failed to like the recepie');
          likeRecepie(
            LikeRecepieParams(
              recepieId: this.recepie.value,
              userId: this.userId,
            ),
          );
        },
        (success) {},
      );
    }

    if (event is UpdateCardLikeRecepie) {
      yield RecepieHomeCardInitial();
      if (!isLiked) {
        this.recepie.likes.add(this.userId);
      } else {
        this.recepie.likes.remove(this.userId);
      }
      this.isLiked = !this.isLiked;
      yield RecepieHomeCardLoaded();
    }
  }
}
