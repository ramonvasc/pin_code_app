import 'package:equatable/equatable.dart';

abstract class PinState extends Equatable {
  @override
  List<Object> get props => [];
}

class PinInitial extends PinState {}

class PinMatch extends PinState {}

class PinMismatch extends PinState {}
