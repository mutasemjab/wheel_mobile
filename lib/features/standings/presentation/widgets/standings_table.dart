import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/colors.dart';
import '../../domain/entities/standings.dart';
import '../bloc/standings_cubit.dart';

/// Compact sortable table of every player.
class StandingsTable extends StatelessWidget {
  const StandingsTable({super.key, required this.standings});

  final Standings standings;

  static const List<StandingsSort> _columns = [
    StandingsSort.rating,
    StandingsSort.goals,
    StandingsSort.assists,
    StandingsSort.matches,
  ];

  String _label(BuildContext context, StandingsSort sort) => switch (sort) {
    StandingsSort.rating => context.l10n.sortRating,
    StandingsSort.goals => context.l10n.sortGoals,
    StandingsSort.assists => context.l10n.sortAssists,
    StandingsSort.matches => context.l10n.sortMatches,
  };

  @override
  Widget build(BuildContext context) {
    final view = context.watch<StandingsViewCubit>();
    final sort = view.state.sort;
    final players = standings.sorted(sort);
    return ListView(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            sortColumnIndex: _columns.indexOf(sort) + 1,
            columnSpacing: 20,
            showCheckboxColumn: false,
            columns: [
              DataColumn(label: Text(context.l10n.playerColumn)),
              for (final column in _columns)
                DataColumn(
                  numeric: true,
                  label: Text(_label(context, column)),
                  onSort: (_, _) => view.sortBy(column),
                ),
            ],
            rows: [
              for (final p in players)
                DataRow(
                  onSelectChanged: (_) =>
                      context.push(AppRoutes.player(p.slug)),
                  cells: [
                    DataCell(
                      Text(
                        p.name,
                        style: TextStyle(
                          color: p.tierNow == null
                              ? null
                              : AppColors.tier(p.tierNow!),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    DataCell(Text('${p.rating}')),
                    DataCell(Text('${p.stats.g}')),
                    DataCell(Text('${p.stats.a}')),
                    DataCell(Text('${p.stats.mp}')),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
