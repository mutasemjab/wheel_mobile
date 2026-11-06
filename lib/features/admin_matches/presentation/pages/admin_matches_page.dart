import 'package:flutter/material.dart';

import '../../../../app/routes.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../matches/presentation/widgets/matches_list_view.dart';

/// `GET /admin/matches?page=` returns public match objects + `meta`, so the
/// public list widget and `MatchesBloc` are reused.
class AdminMatchesPage extends StatelessWidget {
  const AdminMatchesPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.finishedMatches)),
    body: const MatchesListView(routeFor: AppRoutes.adminMatch),
  );
}
