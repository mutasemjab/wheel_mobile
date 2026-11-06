import 'package:flutter_test/flutter_test.dart';
import 'package:wheel_mobile/core/utils/match_clock.dart';
import 'package:wheel_mobile/core/widgets/live_scoreboard.dart';

import '../helpers/pump_app.dart';

LiveScoreboard _board({int? acc, int? runAt}) => LiveScoreboard(
  opponent: 'رجائي',
  us: 2,
  them: 1,
  clock: MatchClock.read(accMs: acc, runAtMs: runAt, deviceNowMs: 1000000),
);

void main() {
  testWidgets('before kick-off shows "قبل البداية"', (tester) async {
    await pumpApp(tester, _board());
    expect(find.text('قبل البداية'), findsOneWidget);
    expect(find.text('2 – 1'), findsOneWidget);
    expect(find.text('رجائي'), findsOneWidget);
  });

  testWidgets('paused with time on the clock shows "استراحة"', (tester) async {
    await pumpApp(tester, _board(acc: 25 * 60000));
    expect(find.text('استراحة'), findsOneWidget);
    expect(find.text('25:00'), findsOneWidget);
  });

  testWidgets('running shows the minute', (tester) async {
    await pumpApp(tester, _board(acc: 0, runAt: 1000000 - 12 * 60000));
    expect(find.text("13'"), findsOneWidget);
  });
}
