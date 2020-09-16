import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../domain/usecases/services/dialog_service.dart';
import '../../../mitra_screens/select_mitra_screen/select_mitra_screen.dart';

import '../../../../../domain/entities/mitra/mitra.dart';
import '../../../../../domain/usecases/mitra/get_mitras.dart';
import '../../../../../domain/usecases/mitra/set_mitra.dart';

part 'mitra_event.dart';
part 'mitra_state.dart';

class MitraBloc extends Bloc<MitraEvent, MitraState> {
  final GetMitras getMitras;
  final SetMitra setMitra;

  MitraBloc({
    @required this.getMitras,
    @required this.setMitra,
  }) : super(MitraInitial());

  List mitras = List();
  Mitra selMitra;
  bool loaded = false;
  String userId;

  @override
  Stream<MitraState> mapEventToState(
    MitraEvent event,
  ) async* {
    if (event is MitraInitEvent) {
      print('[sys] : fetching mitras');
      yield MitraLoading();
      if (!loaded) {
        final failureOrMitras = await getMitras(GetMitrasParams(event.userId));
        yield* failureOrMitras.fold(
          (failure) async* {
            print('[err] : fetching mitras failed : ${failure.code}');
          },
          (mitras) async* {
            print('[sys] : mitras succesfully fetched : $mitras');
            this.mitras = mitras;
            this.mitras.sort((a, b) => a.customers > b.customers ? -1 : 1);
            this.mitras.sort((a, b) => a.active == b.active ? 0 : a.active ? -1 : 1);
            this.loaded = true;
            this.userId = event.userId;
            if (event.mitraId != null) {
              this.selMitra = mitras[mitras.indexWhere(
                (element) => element.mitraId == event.mitraId,
              )];
            }
            yield MitraLoaded(mitras: mitras, selMitra: this.selMitra);
          },
        );
      } else {
        yield MitraLoaded(mitras: this.mitras, selMitra: this.selMitra);
      }
    }

    if (event is MitraSelectEvent) {
      if (this.selMitra == null || event.mitra.mitraId != this.selMitra.mitraId) {
        if (!event.mitra.active) {
          DialogService.display(
            context: selectMitraKey.currentContext,
            title: 'Mitra Inactive',
            content: 'The mitra you have selected is currently inactive, please select another mitra.',
          );
          return;
        }
        print('[sys] : changing mitra : ${event.mitra.mitraId}');
        yield MitraLoaded(
          mitras: this.mitras,
          selMitra: this.selMitra,
          mitraChanged: true,
          postingMitra: true,
        );
        final failureOrSuccess = await setMitra(
          SetMitraParams(
            mitraId: event.mitra.mitraId,
            userId: this.userId,
          ),
        );
        yield* failureOrSuccess.fold(
          (failure) async* {
            print('[err] : Failed to update mitra : ${failure.code}');
            yield MitraLoaded(
              mitras: this.mitras,
              selMitra: this.selMitra,
              mitraChanged: true,
              postingMitra: false,
            );
          },
          (success) async* {
            print('[sys] : mitra updated');
            this.mitras[this.mitras.indexWhere((element) => element.mitraId == event.mitra.mitraId)].customers -= 1;
            this.selMitra = event.mitra;
            this.selMitra.customers += 1;
            yield MitraLoaded(
              mitras: this.mitras,
              selMitra: this.selMitra,
              mitraChanged: true,
              postingMitra: false,
            );
          },
        );
      }

      // print('[sys] : mitra updated');
      // this
      //     .mitras[this
      //         .mitras
      //         .indexWhere((element) => element.mitraId == event.mitra.mitraId)]
      //     .customers -= 1;
      // this.selMitra = event.mitra;
      // print('[dbg] : ${this.selMitra.customers}');
      // this.selMitra.customers += 1;
      // print('[dbg] : ${this.selMitra.customers}');
      // yield MitraLoaded(
      //   mitras: this.mitras,
      //   selMitra: this.selMitra,
      //   mitraChanged: true,
      // );
    }
  }
}
