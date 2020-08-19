import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../domain/usecases/categories/search_products.dart';
import '../../../../domain/usecases/categories/search_recepies.dart';
import '../home_search_screen.dart';

part 'home_search_event.dart';
part 'home_search_state.dart';

class HomeSearchBloc extends Bloc<HomeSearchEvent, HomeSearchState> {
  final SearchProducts searchProducts;
  final SearchRecepies searchRecepies;

  HomeSearchBloc({
    @required this.searchProducts,
    @required this.searchRecepies,
  }) : super(HomeSearchInitial());

  String type;
  List<Widget> searchRes = List<Widget>();
  String prevSearch;

  int lastTap = 0;

  @override
  Stream<HomeSearchState> mapEventToState(
    HomeSearchEvent event,
  ) async* {
    if (event is HomeSearchInit) {
      this.type = event.type;
    }
    if (event is SearchProductsEvent) {
      if (event.search.trim() != null &&
          event.search.trim() != '' &&
          this.prevSearch != event.search) {
        int currTap = DateTime.now().millisecondsSinceEpoch;
        print('[dbg] : ${currTap - lastTap}');
        if (lastTap != 0) {
          if (currTap - lastTap < 1000) {
            print('[dbg] : fast typing');
            this.lastTap = currTap;
            return;
          } else {
            print('[dbg] : type finished');
            this.lastTap = currTap;
          }
        }
        this.lastTap = currTap;
        this.prevSearch = event.search;
        yield HomeSearchLoading();
        var failureOrSearchRes;

        if (this.type == 'recepie') {
          failureOrSearchRes = await searchRecepies(
            event.search.trim(),
          );
        } else {
          failureOrSearchRes = await searchProducts(
            SearchParams(event.search.trim()),
          );
        }

        yield* failureOrSearchRes.fold(
          (l) async* {
            print('[err] : failed to get search results');
          },
          (searchRes) async* {
            print('[sys] : search res fetched');
            List<Widget> list = List<Widget>();

            if (searchRes.length == 0) {
              list.add(Text('No results'));
            } else {
              searchRes.forEach((searchRes) {
                searchRes.categories.forEach((category) {
                  list.add(SearchResults(
                    searchResponse: searchRes,
                    category: category,
                  ));
                });
              });
            }

            list.shuffle();
            this.searchRes = list;
            yield HomeSearchLoaded();
          },
        );
      } else {
        this.prevSearch = null;
        yield HomeSearchInitial();
      }
    }
  }
}
