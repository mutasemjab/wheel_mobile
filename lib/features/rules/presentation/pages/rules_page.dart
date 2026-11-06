import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/number_format.dart';
import '../../../../core/widgets/data_state_view.dart';
import '../../../../core/widgets/section_card.dart';
import '../../domain/entities/rules.dart';
import '../bloc/rules_cubit.dart';

/// Fully server-driven rules: points table, worked examples, walk examples.
class RulesPage extends StatelessWidget {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.rulesTitle)),
    body: DataStateView<RulesCubit, Rules>(
      builder: (context, rules) {
        final l10n = context.l10n;
        const gap = SizedBox(height: AppSpacing.md);
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            SectionCard(
              title: l10n.pointsTable,
              child: Column(
                children: [
                  for (final row in rules.pointsTable)
                    _PointsLine(label: row.label, pts: row.value),
                ],
              ),
            ),
            if (rules.examples.isNotEmpty) ...[
              gap,
              SectionCard(
                title: l10n.examples,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final ex in rules.examples) ...[
                      Text(
                        ex.title,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      for (final part in ex.parts)
                        _PointsLine(label: part.label, pts: part.pts),
                      _PointsLine(label: l10n.total, pts: ex.total, bold: true),
                      const Divider(),
                    ],
                  ],
                ),
              ),
            ],
            if (rules.walkExamples.isNotEmpty) ...[
              gap,
              SectionCard(
                title: l10n.walkExamples,
                child: _WalkTable(rows: rules.walkExamples),
              ),
            ],
          ],
        );
      },
    ),
  );
}

class _PointsLine extends StatelessWidget {
  const _PointsLine({
    required this.label,
    required this.pts,
    this.bold = false,
  });

  final String label;
  final double pts;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = bold ? Theme.of(context).textTheme.titleSmall : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(
            NumberFormatX.compact(pts),
            style: (style ?? const TextStyle()).copyWith(
              color: AppColors.delta(pts),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _WalkTable extends StatelessWidget {
  const _WalkTable({required this.rows});

  final List<WalkExample> rows;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text(l10n.walkRating), numeric: true),
          DataColumn(label: Text(l10n.walkPoints), numeric: true),
          DataColumn(label: Text(l10n.walkStep), numeric: true),
          DataColumn(label: Text(l10n.walkNewRating), numeric: true),
        ],
        rows: [
          for (final w in rows)
            DataRow(
              cells: [
                DataCell(Text(NumberFormatX.compact(w.r))),
                DataCell(Text(NumberFormatX.compact(w.pts))),
                DataCell(Text(NumberFormatX.compact(w.step))),
                DataCell(Text(NumberFormatX.compact(w.newRating))),
              ],
            ),
        ],
      ),
    );
  }
}
