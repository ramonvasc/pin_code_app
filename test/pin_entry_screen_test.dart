import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pin_code_app/screens/pin_entry_screen.dart';

void main() {
  testWidgets('PinEntryScreen has 4 TextFields', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PinEntryScreen()));

    expect(find.byType(TextField), findsNWidgets(4));
  });
}
