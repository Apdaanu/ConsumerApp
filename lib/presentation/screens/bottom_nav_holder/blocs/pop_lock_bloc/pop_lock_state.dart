part of 'pop_lock_bloc.dart';

abstract class PopLockState extends Equatable {
  const PopLockState();
  
  @override
  List<Object> get props => [];
}

class PopLockInitial extends PopLockState {}
