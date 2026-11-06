import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/state_views.dart';
import '../bloc/auth_bloc.dart';

/// Admin entry: tiles shown according to `permissions`.
class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final user = context.watch<AuthBloc>().state.user;
    if (user == null) return const Scaffold(body: LoadingView());
    final tiles = [
      if (user.canManageLive)
        (Icons.sensors_rounded, l10n.liveDesk, AppRoutes.liveDesk),
      if (user.canEditMatches)
        (
          Icons.sports_soccer_rounded,
          l10n.finishedMatches,
          AppRoutes.adminMatches,
        ),
      if (user.canManagePlayers)
        (Icons.groups_rounded, l10n.playersAdmin, AppRoutes.adminPlayers),
      if (user.canEditConfig)
        (Icons.tune_rounded, l10n.settings, AppRoutes.adminSettings),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.adminPanel),
        actions: [
          IconButton(
            tooltip: l10n.logout,
            onPressed: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
              context.go(AppRoutes.more);
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            l10n.adminHello(user.name),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(user.email, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: AppSpacing.lg),
          if (tiles.isEmpty) EmptyView(message: l10n.noPermissions),
          for (final (icon, label, route) in tiles) ...[
            Card(
              child: ListTile(
                minVerticalPadding: AppSpacing.lg,
                leading: Icon(icon, size: 32),
                title: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                trailing: const Icon(Icons.chevron_left_rounded),
                onTap: () => context.push(route),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
