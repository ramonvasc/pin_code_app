abstract class PinEvent {}

class PinEntered extends PinEvent {
  final String pin;
  PinEntered(this.pin);
}

class PinConfirmed extends PinEvent {
  final String pin;
  PinConfirmed(this.pin);
}

class PinReset extends PinEvent {}
