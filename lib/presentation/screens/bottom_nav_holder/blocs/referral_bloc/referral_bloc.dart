import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freshOk/core/usecases/usecase.dart';
import 'package:freshOk/domain/entities/referral/referral.dart';
import 'package:freshOk/domain/usecases/referral/get_referrals.dart';

part 'referral_event.dart';
part 'referral_state.dart';

class ReferralBloc extends Bloc<ReferralEvent, ReferralState> {
  final GetReferrals getReferrals;

  ReferralBloc(this.getReferrals) : super(ReferralInitial());

  Referral referral;
  bool loaded = false;

  @override
  Stream<ReferralState> mapEventToState(
    ReferralEvent event,
  ) async* {
    if (event is ReferralInitEvent) {
      yield ReferralLoading();
      if (!loaded) {
        print('[sys] : fetching referrals');
        final failureOrReferral = await getReferrals(NoParams());
        yield* failureOrReferral.fold(
          (failure) async* {
            print('[err] : fetching referrals failed');
          },
          (referral) async* {
            print('[sys] : fetched referrals');
            this.referral = referral;
            this.loaded = true;
            yield ReferralLoaded(referral);
          },
        );
      } else {
        yield ReferralLoaded(this.referral);
      }
    }
  }
}
