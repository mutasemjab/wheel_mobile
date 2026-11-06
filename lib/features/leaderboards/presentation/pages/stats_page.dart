import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../awards/presentation/pages/awards_view.dart';
import 'leaderboards_view.dart';

/// "الإحصائيات": leaderboards and awards tabs.
class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.navStats),
        bottom: TabBar(
          tabs: [
            Tab(text: context.l10n.leaderboards),
            Tab(text: context.l10n.awards),
          ],
        ),
      ),
      body: const TabBarView(children: [LeaderboardsView(), AwardsView()]),
    ),
  );
}
