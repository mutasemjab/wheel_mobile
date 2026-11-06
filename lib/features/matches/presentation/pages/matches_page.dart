import 'package:flutter/material.dart';

import '../../../../app/routes.dart';
import '../../../../core/l10n/l10n.dart';
import '../widgets/matches_list_view.dart';

class MatchesPage extends StatelessWidget {
  const MatchesPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.matchesTitle)),
    body: const MatchesListView(routeFor: AppRoutes.match),
  );
}
