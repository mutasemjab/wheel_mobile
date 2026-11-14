import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/data_state_view.dart';
import '../../../../core/widgets/player_avatar.dart';
import '../../../players/domain/entities/player.dart';
import '../bloc/compare_cubit.dart';

/// "مقارنة لاعبين": pick two players and compare their numbers side by side.
class ComparePage extends StatelessWidget {
  const ComparePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.compareTitle)),
    body: DataStateView<CompareCubit, List<Player>>(
      isEmpty: (players) => players.length < 2,
      builder: (context, players) => _CompareBody(players: players),
    ),
  );
}

class _CompareBody extends StatefulWidget {
  const _CompareBody({required this.players});

  final List<Player> players;

  @override
  State<_CompareBody> createState() => _CompareBodyState();
}

class _CompareBodyState extends State<_CompareBody> {
  // Selection is view state only; defaults to the top two ranked players.
  late String _left = _byRank[0].slug;
  late String _right = _byRank[1].slug;

  List<Player> get _byRank =>
      [...widget.players]..sort((a, b) => a.rank.compareTo(b.rank));

  Player _find(String slug) => widget.players.firstWhere(
    (p) => p.slug == slug,
    orElse: () => _byRank[0],
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final a = _find(_left);
    final b = _find(_right);
    final rows = compareRows(
      a,
      b,
      rating: l10n.rating,
      matches: l10n.statMatches,
      goals: l10n.statGoals,
      assists: l10n.statAssists,
      goalsAssists: l10n.statGoalsAssists,
      goalsPerMatch: l10n.statGoalsPerMatch,
      saves: l10n.statSaves,
      tackles: l10n.statTackles,
      motm: l10n.statMotm,
      wins: l10n.statWins,
    );
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(
          l10n.compareHint,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _PlayerPicker(
                players: _byRank,
                selected: a,
                color: AppColors.accent,
                onChanged: (slug) => setState(() => _left = slug),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _PlayerPicker(
                players: _byRank,
                selected: b,
                color: AppColors.accentSecondary,
                onChanged: (slug) => setState(() => _right = slug),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [for (final row in rows) _CompareRowView(row: row)],
            ),
          ),
        ),
      ],
    );
  }
}

class _PlayerPicker extends StatelessWidget {
  const _PlayerPicker({
    required this.players,
    required this.selected,
    required this.color,
    required this.onChanged,
  });

  final List<Player> players;
  final Player selected;
  final Color color;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radius),
      side: BorderSide(color: color, width: 2),
    ),
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          PlayerAvatar(
            name: selected.name,
            photoUrl: selected.photoUrl,
            tier: selected.tierNow,
            size: 64,
          ),
          const SizedBox(height: AppSpacing.sm),
          DropdownButton<String>(
            isExpanded: true,
            value: selected.slug,
            hint: Text(context.l10n.comparePick),
            underline: const SizedBox.shrink(),
            items: [
              for (final p in players)
                DropdownMenuItem(
                  value: p.slug,
                  child: Text(p.name, overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: (slug) {
              if (slug != null) onChanged(slug);
            },
          ),
        ],
      ),
    ),
  );
}

class _CompareRowView extends StatelessWidget {
  const _CompareRowView({required this.row});

  final CompareRow row;

  static const double _barHeight = 8;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final (leftShare, rightShare) = row.shares;
    String fmt(double v) => v.toStringAsFixed(row.decimals);
    Widget bar(double share, Color color, AlignmentDirectional align) =>
        ClipRRect(
          borderRadius: BorderRadius.circular(_barHeight),
          child: SizedBox(
            height: _barHeight,
            child: Align(
              alignment: align,
              child: FractionallySizedBox(
                widthFactor: share.clamp(0.02, 1),
                child: ColoredBox(color: color),
              ),
            ),
          ),
        );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        children: [
          Row(
            children: [
              Text(fmt(row.left), style: text.titleSmall),
              Expanded(
                child: Text(
                  row.label,
                  textAlign: TextAlign.center,
                  style: text.labelMedium,
                ),
              ),
              Text(fmt(row.right), style: text.titleSmall),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: bar(
                  leftShare,
                  AppColors.accent,
                  AlignmentDirectional.centerEnd,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: bar(
                  rightShare,
                  AppColors.accentSecondary,
                  AlignmentDirectional.centerStart,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
