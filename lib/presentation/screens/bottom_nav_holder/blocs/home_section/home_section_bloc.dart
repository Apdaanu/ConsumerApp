import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/entities/user_details.dart';

import '../../../../../domain/usecases/categories/get_home_sections.dart';
import '../../../../../domain/usecases/user_details/get_user_details.dart';

part 'home_section_event.dart';
part 'home_section_state.dart';

class HomeSectionBloc extends Bloc<HomeSectionEvent, HomeSectionState> {
  final GetHomeSections getHomeSections;
  final GetUserDetails getUserDetails;
  HomeSectionBloc({
    @required this.getHomeSections,
    @required this.getUserDetails,
  }) : super(HomeSectionInitial());

  @override
  Stream<HomeSectionState> mapEventToState(
    HomeSectionEvent event,
  ) async* {
    if (event is HomeSectionInitEvent) {
      yield HomeSectionLoading();
      final failureOrUserDetails = await getUserDetails(NoParams());
      yield* failureOrUserDetails.fold(
        (failure) async* {
          print(
              '[sys] : failure in fetching user_details, home_Section_bloc : ${failure.code}');
        },
        (userDetails) async* {
          print('[sys] : fetching home sections');
          final failureOrSections =
              await getHomeSections(SectionParams(userId: userDetails.userId));
          yield* failureOrSections.fold(
            (failure) async* {
              print(
                  '[sys] : failure in  fetching home sections: ${failure.code}');
            },
            (sections) async* {
              print('[sys] : fetched home sections');
              yield HomeSectionLoaded(sections);
            },
          );
        },
      );
    }
  }
}
