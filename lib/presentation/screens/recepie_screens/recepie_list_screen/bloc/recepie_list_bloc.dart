import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/domain/usecases/categories/like_recepie.dart';

import '../../../../../domain/usecases/categories/get_products.dart';
import '../../../../../domain/usecases/categories/get_recepies.dart';

part 'recepie_list_event.dart';
part 'recepie_list_state.dart';

class RecepieListBloc extends Bloc<RecepieListEvent, RecepieListState> {
  final GetProducts getProducts;
  final GetRecepies getRecepies;
  final LikeRecepie likeRecepie;

  RecepieListBloc({
    @required this.getProducts,
    @required this.getRecepies,
    @required this.likeRecepie,
  }) : super(RecepieListInitial());

  List recepies;
  String userId;

  @override
  Stream<RecepieListState> mapEventToState(
    RecepieListEvent event,
  ) async* {
    if (event is RecepieListInit) {
      if (event.whichPage == 'recepie') {
        yield RecepieListLoading();
        print('[sys] : fetching recepie list');
        final failureOrRecepies = await getRecepies(
          GetRecepiesParams(
            userId: event.userId,
            sectionId: event.sectioId,
            categoryId: event.categoryId,
            type: event.type,
          ),
        );
        yield* failureOrRecepies.fold(
          (failure) async* {
            print('[sys] : fetching recepie list failed : ${failure.code}');
          },
          (recepies) async* {
            print('[sys] : recepie fetched!');
            this.recepies = recepies;
            this.userId = event.userId;
            yield RecepieListLoaded(recepies);
          },
        );
      } else {
        yield RecepieListLoading();
        print('[sys] : fetching recepie list');
        final failureOrRecepies = await getProducts(
          GetProductsParams(
            userId: event.userId,
            sectionId: event.sectioId,
            categoryId: event.categoryId,
            type: 'recipeCategory',
          ),
        );
        yield* failureOrRecepies.fold(
          (failure) async* {
            print('[sys] : fetching recepie list failed : ${failure.code}');
          },
          (recepies) async* {
            print('[sys] : recepie fetched!');
            this.recepies = recepies;
            this.userId = event.userId;
            yield RecepieListLoaded(recepies);
          },
        );
      }
    }

    if (event is RecepieSearchEvent) {
      yield RecepieListInitial();
      List searchRes = this
          .recepies
          .where((element) =>
              element.title.toLowerCase().indexOf(event.search.toLowerCase()) !=
              -1)
          .toList();
      yield RecepieListLoaded(searchRes);
    }

    if (event is LikeRecepieEvent) {
      print('[dbg] : Liking recepie');
      yield RecepieListInitial();
      _toggleLike(event.recepieId);
      yield RecepieListLoaded(this.recepies);
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

    if (event is UpdateRecepieLike) {
      print('[dbg] : updating previous like');
      yield RecepieListInitial();
      _toggleLike(event.recepieId);
      yield RecepieListLoaded(this.recepies);
    }
  }

  void _toggleLike(recepieId) {
    List likes = this
        .recepies[
            this.recepies.indexWhere((element) => element.id == recepieId)]
        .likes;
    print('[dbg] : $likes');
    if (likes.indexOf(this.userId) == -1) {
      print('[dbg] : liking');
      this
          .recepies[
              this.recepies.indexWhere((element) => element.id == recepieId)]
          .likes
          .add(this.userId);
    } else {
      print('[dbg] : unliking');
      this
          .recepies[
              this.recepies.indexWhere((element) => element.id == recepieId)]
          .likes
          .remove(this.userId);
    }
  }
}
