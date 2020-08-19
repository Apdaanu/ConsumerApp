part of 'pop_lock_bloc.dart';

abstract class PopLockEvent extends Equatable {
  const PopLockEvent();

  @override
  List<Object> get props => [];
}

class PopLockAcquire extends PopLockEvent {
  final next;

  PopLockAcquire(this.next);
}

class PopLockRelease extends PopLockEvent {}
