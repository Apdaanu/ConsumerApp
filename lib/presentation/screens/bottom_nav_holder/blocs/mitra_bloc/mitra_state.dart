part of 'mitra_bloc.dart';

abstract class MitraState extends Equatable {
  const MitraState();
}

class MitraInitial extends MitraState {
  @override
  List<Object> get props => [];
}

class MitraLoading extends MitraState {
  @override
  List<Object> get props => [];
}

class MitraLoaded extends MitraState {
  final List mitras;
  final Mitra selMitra;
  final bool mitraChanged;
  final bool postingMitra;

  MitraLoaded(
      {@required this.mitras,
      @required this.selMitra,
      this.mitraChanged,
      this.postingMitra});

  @override
  List<Object> get props => [
        mitras,
        selMitra,
        mitraChanged,
        postingMitra,
      ];
}
