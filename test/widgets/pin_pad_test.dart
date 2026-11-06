import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheel_mobile/features/auth/presentation/widgets/pin_pad.dart';

import '../helpers/pump_app.dart';

Future<void> _tap(WidgetTester tester, String digits) async {
  for (final d in digits.split('')) {
    await tester.tap(find.text(d));
    await tester.pump();
  }
}

void main() {
  testWidgets('auto-submits at the maximum length', (tester) async {
    String? submitted;
    await pumpApp(
      tester,
      SingleChildScrollView(child: PinPad(onSubmit: (p) => submitted = p)),
    );
    await _tap(tester, '123456');
    expect(submitted, '123456');
  });

  testWidgets('✓ submits a 4-digit PIN; disabled below the minimum', (
    tester,
  ) async {
    String? submitted;
    await pumpApp(
      tester,
      SingleChildScrollView(child: PinPad(onSubmit: (p) => submitted = p)),
    );
    await _tap(tester, '12');
    await tester.tap(find.byIcon(Icons.check_rounded));
    await tester.pump();
    expect(submitted, isNull);
    await _tap(tester, '34');
    await tester.tap(find.byIcon(Icons.check_rounded));
    await tester.pump();
    expect(submitted, '1234');
  });

  testWidgets('backspace removes the last digit', (tester) async {
    String? submitted;
    await pumpApp(
      tester,
      SingleChildScrollView(child: PinPad(onSubmit: (p) => submitted = p)),
    );
    await _tap(tester, '12345');
    await tester.tap(find.byIcon(Icons.backspace_outlined));
    await tester.pump();
    await _tap(tester, '90');
    expect(submitted, '123490');
  });

  testWidgets('disabled pad ignores input', (tester) async {
    String? submitted;
    await pumpApp(
      tester,
      SingleChildScrollView(
        child: PinPad(enabled: false, onSubmit: (p) => submitted = p),
      ),
    );
    await _tap(tester, '123456');
    expect(submitted, isNull);
  });
}
