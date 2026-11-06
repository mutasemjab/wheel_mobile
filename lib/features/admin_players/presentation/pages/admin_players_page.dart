import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/data_state_view.dart';
import '../../../../core/widgets/player_avatar.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../core/widgets/tier_badge.dart';
import '../../domain/entities/admin_player.dart';
import '../bloc/admin_players_cubit.dart';

class AdminPlayersPage extends StatelessWidget {
  const AdminPlayersPage({
    super.key,
    required this.canCreate,
    required this.canUpdate,
    required this.canDelete,
  });

  final bool canCreate;
  final bool canUpdate;
  final bool canDelete;

  Future<void> _open(
    BuildContext context,
    String route, {
    AdminPlayer? player,
  }) async {
    final cubit = context.read<AdminPlayersCubit>();
    await context.push(route, extra: player);
    await cubit.refresh();
  }

  Future<void> _delete(BuildContext context, AdminPlayer player) async {
    final cubit = context.read<AdminPlayersCubit>();
    final ok = await confirmDialog(
      context,
      message: context.l10n.deletePlayerConfirm(player.name),
      destructive: true,
    );
    if (ok) await cubit.delete(player.slug);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.playersAdmin)),
      floatingActionButton: canCreate
          ? FloatingActionButton.extended(
              onPressed: () => _open(context, AppRoutes.adminPlayerNew),
              icon: const Icon(Icons.person_add_rounded),
              label: Text(l10n.newPlayer),
            )
          : null,
      body: DataStateView<AdminPlayersCubit, List<AdminPlayer>>(
        isEmpty: (players) => players.isEmpty,
        builder: (context, players) => Column(
          children: [
            if (canUpdate)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Text(
                  l10n.reorderHint,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            Expanded(
              child: ReorderableListView.builder(
                buildDefaultDragHandles: canUpdate,
                padding: const EdgeInsets.only(bottom: 96),
                itemCount: players.length,
                onReorder: context.read<AdminPlayersCubit>().move,
                itemBuilder: (context, i) {
                  final p = players[i];
                  return ListTile(
                    key: ValueKey(p.slug),
                    leading: PlayerAvatar(
                      name: p.name,
                      photoUrl: p.photoUrl,
                      tier: p.startTier,
                      size: 40,
                    ),
                    title: Text(
                      p.number == null ? p.name : '${p.name} · ${p.number}',
                    ),
                    subtitle: Text(
                      [p.slug, if (!p.isActive) l10n.inactive].join(' · '),
                    ),
                    onTap: canUpdate
                        ? () => _open(
                            context,
                            AppRoutes.adminPlayerEdit(p.slug),
                            player: p,
                          )
                        : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TierBadge(tier: p.startTier),
                        if (canDelete)
                          IconButton(
                            tooltip: l10n.deletePlayer,
                            onPressed: () => _delete(context, p),
                            icon: const Icon(Icons.delete_outline_rounded),
                          ),
                        if (canUpdate) const SizedBox(width: AppSpacing.xl),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
