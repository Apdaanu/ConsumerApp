part of 'mitra_bloc.dart';

abstract class MitraEvent extends Equatable {
  const MitraEvent();
}

class MitraInitEvent extends MitraEvent {
  final String mitraId;
  final String userId;

  MitraInitEvent({
    @required this.mitraId,
    @required this.userId,
  });

  @override
  List<Object> get props => [mitraId];
}

class MitraSelectEvent extends MitraEvent {
  final Mitra mitra;

  MitraSelectEvent(this.mitra);

  @override
  List<Object> get props => throw UnimplementedError();
}
