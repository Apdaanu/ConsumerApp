part of 'referral_bloc.dart';

abstract class ReferralEvent extends Equatable {
  const ReferralEvent();
}

class ReferralInitEvent extends ReferralEvent {
  @override
  List<Object> get props => [];
}
