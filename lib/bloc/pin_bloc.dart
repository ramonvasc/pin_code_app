import 'package:flutter_bloc/flutter_bloc.dart';
import 'pin_event.dart';
import 'pin_state.dart';

class PinBloc extends Bloc<PinEvent, PinState> {
  String? _firstEnteredPin;

  PinBloc() : super(PinInitial()) {
    on<PinEntered>((event, emit) {
      _firstEnteredPin = event.pin;
    });
    on<PinConfirmed>((event, emit) {
      if (_firstEnteredPin == event.pin) {
        emit(PinMatch());
      } else {
        emit(PinMismatch());
      }
    });
    on<PinReset>((event, emit) => emit(PinInitial()));
  }
}
