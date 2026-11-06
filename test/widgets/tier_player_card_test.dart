import 'package:flutter_test/flutter_test.dart';
import 'package:wheel_mobile/core/entities/enums.dart';
import 'package:wheel_mobile/features/home/domain/entities/home_data.dart';
import 'package:wheel_mobile/features/home/presentation/widgets/tier_player_card.dart';

import '../helpers/pump_app.dart';

TierPlayer _player({double trend = 0, Movement moved = Movement.none}) =>
    TierPlayer(
      slug: 'hassan',
      name: 'حسن',
      rating: 82,
      ratingExact: 81.5,
      rank: 1,
      trend: trend,
      moved: moved,
    );

void main() {
  testWidgets('shows rank, rating, ▲ trend and "صعد" when moved up', (
    tester,
  ) async {
    await pumpApp(
      tester,
      TierPlayerCard(
        player: _player(trend: 1.5, moved: Movement.up),
        tier: Tier.a,
      ),
    );
    expect(find.text('حسن'), findsOneWidget);
    expect(find.text('82'), findsOneWidget);
    expect(find.text('#1'), findsOneWidget);
    expect(find.text('▲ 1.5'), findsOneWidget);
    expect(find.text('صعد'), findsOneWidget);
  });

  testWidgets('shows ▼ and "نزل" when moved down', (tester) async {
    await pumpApp(
      tester,
      TierPlayerCard(
        player: _player(trend: -0.3, moved: Movement.down),
        tier: Tier.b,
      ),
    );
    expect(find.text('▼ 0.3'), findsOneWidget);
    expect(find.text('نزل'), findsOneWidget);
  });

  testWidgets('no trend and no badge when unchanged', (tester) async {
    await pumpApp(tester, TierPlayerCard(player: _player(), tier: Tier.c));
    expect(find.textContaining('▲'), findsNothing);
    expect(find.textContaining('▼'), findsNothing);
    expect(find.text('صعد'), findsNothing);
    expect(find.text('نزل'), findsNothing);
  });
}
