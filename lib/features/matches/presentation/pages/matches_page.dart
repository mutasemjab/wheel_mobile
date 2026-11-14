import 'package:flutter/material.dart';

import '../../../../app/routes.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../fixtures/presentation/pages/fixtures_view.dart';
import '../widgets/matches_list_view.dart';

/// Matches tab: played results and upcoming fixtures.
class MatchesPage extends StatelessWidget {
  const MatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.matchesTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.resultsTab),
              Tab(text: l10n.fixturesTab),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MatchesListView(routeFor: AppRoutes.match),
            FixturesView(),
          ],
        ),
      ),
    );
  }
}
