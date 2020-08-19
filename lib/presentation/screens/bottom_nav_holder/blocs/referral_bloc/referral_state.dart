part of 'referral_bloc.dart';

abstract class ReferralState extends Equatable {
  const ReferralState();
}

class ReferralInitial extends ReferralState {
  @override
  List<Object> get props => [];
}

class ReferralLoading extends ReferralState {
  @override
  List<Object> get props => [];
}

class ReferralLoaded extends ReferralState {
  final Referral referral;

  ReferralLoaded(this.referral);

  @override
  List<Object> get props => [];
}
