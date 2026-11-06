import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/number_format.dart';
import '../../../../core/widgets/section_card.dart';
import '../../domain/entities/leaderboards.dart';

String boardTitle(BuildContext context, BoardKind kind) => switch (kind) {
  BoardKind.goals => context.l10n.boardGoals,
  BoardKind.assists => context.l10n.boardAssists,
  BoardKind.ga => context.l10n.boardGa,
  BoardKind.saves => context.l10n.boardSaves,
  BoardKind.tackles => context.l10n.boardTackles,
  BoardKind.appearances => context.l10n.boardAppearances,
};

/// Top list for one stat.
class BoardCard extends StatelessWidget {
  const BoardCard({super.key, required this.kind, required this.entries});

  final BoardKind kind;
  final List<BoardEntry> entries;

  @override
  Widget build(BuildContext context) => SectionCard(
    title: boardTitle(context, kind),
    child: Column(
      children: [
        for (final e in entries)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            onTap: () => context.push(AppRoutes.player(e.slug)),
            leading: CircleAvatar(
              radius: 14,
              backgroundColor: e.tier == null ? null : AppColors.tier(e.tier!),
              child: Text(
                '${e.rank}',
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
            title: Text(e.name),
            trailing: Text(
              NumberFormatX.compact(e.value),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
      ],
    ),
  );
}
