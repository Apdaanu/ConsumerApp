import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../../domain/entities/categories/ingredient.dart';
import '../../../../../domain/entities/categories/recepie.dart';
import '../../../../../domain/entities/order/local_cart.dart';
import '../../../../../domain/usecases/categories/get_recepie_details.dart';
import '../../../../../domain/usecases/categories/like_recepie.dart';

part 'recepie_detail_event.dart';
part 'recepie_detail_state.dart';

class RecepieDetailBloc extends Bloc<RecepieDetailEvent, RecepieDetailState> {
  final GetRecepieDetails getRecepieDetails;
  final LikeRecepie likeRecepie;

  RecepieDetailBloc(
    this.getRecepieDetails,
    this.likeRecepie,
  ) : super(RecepieDetailInitial());

  Recepie recepie;
  bool loaded = false;
  bool isLiked = false;
  String userId;

  @override
  Stream<RecepieDetailState> mapEventToState(
    RecepieDetailEvent event,
  ) async* {
    if (event is RecepieDetailsInit) {
      yield RecepieDetailInitial();
      if (!loaded) {
        print('[sys] : fetching recepie details');
        final failureOrRecepie = await getRecepieDetails(
          GetRecepieParams(event.recepieId),
        );
        yield* failureOrRecepie.fold(
          (failure) async* {
            print('[err] : failed to fetch recepie : ${failure.code}');
          },
          (recepie) async* {
            this.recepie = recepie;
            this.loaded = false;
            this.isLiked =
                recepie.likes.indexOf(event.userId) != -1 ? true : false;
            this.userId = event.userId;
            event.cart.cart.forEach((key, value) {
              int idx = this.recepie.ingredients.indexWhere(
                    (element) => element.productId == key,
                  );
              if (idx != -1) this.recepie.ingredients[idx].quantity = value;
            });
            yield RecepieDetailLoaded();
          },
        );
      } else {
        yield RecepieDetailLoaded();
      }
    }

    if (event is RecepieDetailSetQty) {
      yield RecepieDetailInitial();
      recepie.ingredients[recepie.ingredients.indexOf(event.ingredient)]
          .quantity = event.qty;
      yield RecepieDetailLoaded();
    }

    if (event is RecepieDetailLikeEvent) {
      yield RecepieDetailInitial();
      if (!isLiked) {
        this.recepie.likes.add(this.userId);
      } else {
        this.recepie.likes.remove(this.userId);
      }
      this.isLiked = !this.isLiked;

      yield RecepieDetailLoaded();

      final failureOrSuccess = await likeRecepie(
        LikeRecepieParams(
          userId: this.userId,
          recepieId: this.recepie.id,
        ),
      );

      failureOrSuccess.fold(
        (l) {
          likeRecepie(
            LikeRecepieParams(
              userId: this.userId,
              recepieId: this.recepie.id,
            ),
          );
        },
        (r) {},
      );
    }
  }
}
