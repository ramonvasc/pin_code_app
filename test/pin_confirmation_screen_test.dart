import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pin_code_app/bloc/pin_bloc.dart';
import 'package:pin_code_app/bloc/pin_event.dart';
import 'package:pin_code_app/bloc/pin_state.dart';
import 'package:pin_code_app/screens/pin_confirmation_screen.dart';

class MockPinBloc extends MockBloc<PinEvent, PinState> implements PinBloc {}

void main() {
  group('PinConfirmationScreen Tests', () {
    late PinBloc pinBloc;

    setUp(() {
      pinBloc = MockPinBloc();
    });

    testWidgets(
        'renders PinConfirmationScreen with TextFields and Confirm button',
        (WidgetTester tester) async {
      whenListen(
        pinBloc,
        Stream.fromIterable([PinInitial()]),
        initialState: PinInitial(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PinBloc>.value(
            value: pinBloc,
            child: const PinConfirmationScreen(),
          ),
        ),
      );

      // Check for TextFields and Confirm button
      expect(find.byType(TextField), findsNWidgets(4));
      expect(find.text('Confirm PIN'), findsOneWidget);
    });

    testWidgets('shows dialog on PIN match', (WidgetTester tester) async {
      whenListen(
        pinBloc,
        Stream.fromIterable(
            [PinInitial(), PinMatch()]), // Assuming PinMatch leads to a dialog
        initialState: PinInitial(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PinBloc>.value(
            value: pinBloc,
            child: const PinConfirmationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter matched PIN '1234'
      await tester.enterText(find.byType(TextField).at(0), '1');
      await tester.enterText(find.byType(TextField).at(1), '2');
      await tester.enterText(find.byType(TextField).at(2), '3');
      await tester.enterText(find.byType(TextField).at(3), '4');

      // Tap confirm button
      await tester.tap(find.text('Confirm PIN'), warnIfMissed: false);
      await tester.pump(); // Start any animations or state changes
      await tester.pumpAndSettle(); // Wait for them to complete

      // Check for the dialog
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('The PIN codes match.'), findsOneWidget);

      // Optionally, tap on the button in the dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
    });

    testWidgets('shows error on PIN mismatch', (WidgetTester tester) async {
      whenListen(
        pinBloc,
        Stream.fromIterable([PinInitial(), PinMismatch()]),
        initialState: PinInitial(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PinBloc>.value(
            value: pinBloc,
            child: const PinConfirmationScreen(),
          ),
        ),
      );

      // Enter mismatched PIN '1234'
      await tester.enterText(find.byType(TextField).at(0), '1');
      await tester.enterText(find.byType(TextField).at(1), '2');
      await tester.enterText(find.byType(TextField).at(2), '3');
      await tester.enterText(find.byType(TextField).at(3), '4');

      // Tap confirm button
      await tester.tap(find.text('Confirm PIN'));
      await tester.pump(); // Start the timer
      await tester.pump(const Duration(seconds: 2)); // Complete the timer

      // Check for error message (e.g., Snackbar)
      expect(find.text('PIN does not match. Try again.'), findsOneWidget);
    });
  });
}
