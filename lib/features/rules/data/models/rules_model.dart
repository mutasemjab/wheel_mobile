import '../../../../core/utils/json_parsing.dart';
import '../../domain/entities/rules.dart';

class RulesModel {
  const RulesModel({
    required this.pointsTable,
    required this.examples,
    required this.walkExamples,
  });

  factory RulesModel.fromJson(Json json) => RulesModel(
    pointsTable: [
      for (final row in asMapList(json['points_table']))
        PointRow(
          label: asString(row['label']),
          key: asString(row['key']),
          value: asDouble(row['value']),
        ),
    ],
    examples: [
      for (final ex in asMapList(json['examples']))
        RuleExample(
          title: asString(ex['title']),
          parts: [
            for (final part in asMapList(ex['parts']))
              RulePart(
                label: asString(part['label']),
                pts: asDouble(part['pts']),
              ),
          ],
          total: asDouble(ex['total']),
        ),
    ],
    walkExamples: [
      for (final w in asMapList(json['walk_examples']))
        WalkExample(
          r: asDouble(w['r']),
          pts: asDouble(w['pts']),
          step: asDouble(w['step']),
          newRating: asDouble(w['new_rating']),
        ),
    ],
  );

  final List<PointRow> pointsTable;
  final List<RuleExample> examples;
  final List<WalkExample> walkExamples;

  Rules toEntity() => Rules(
    pointsTable: pointsTable,
    examples: examples,
    walkExamples: walkExamples,
  );
}
