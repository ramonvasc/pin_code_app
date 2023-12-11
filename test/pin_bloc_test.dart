import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pin_code_app/bloc/pin_bloc.dart';
import 'package:pin_code_app/bloc/pin_event.dart';
import 'package:pin_code_app/bloc/pin_state.dart';

void main() {
  group('PinBloc', () {
    blocTest<PinBloc, PinState>(
      'emits [PinMatch] when PinConfirmed is added and the pins match',
      build: () => PinBloc(),
      act: (bloc) {
        bloc.add(PinEntered('1234'));
        bloc.add(PinConfirmed('1234'));
      },
      expect: () => [isA<PinMatch>()],
    );

    blocTest<PinBloc, PinState>(
      'emits [PinMismatch] when PinConfirmed is added and the pins do not match',
      build: () => PinBloc(),
      act: (bloc) {
        bloc.add(PinEntered('1234'));
        bloc.add(PinConfirmed('4321'));
      },
      expect: () => [isA<PinMismatch>()],
    );
  });
}
