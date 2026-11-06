import 'package:equatable/equatable.dart';

final class PointRow extends Equatable {
  const PointRow({required this.label, required this.key, required this.value});

  final String label;
  final String key;
  final double value;

  @override
  List<Object?> get props => [label, key, value];
}

final class RulePart extends Equatable {
  const RulePart({required this.label, required this.pts});

  final String label;
  final double pts;

  @override
  List<Object?> get props => [label, pts];
}

final class RuleExample extends Equatable {
  const RuleExample({
    required this.title,
    this.parts = const [],
    required this.total,
  });

  final String title;
  final List<RulePart> parts;
  final double total;

  @override
  List<Object?> get props => [title, parts, total];
}

final class WalkExample extends Equatable {
  const WalkExample({
    required this.r,
    required this.pts,
    required this.step,
    required this.newRating,
  });

  final double r;
  final double pts;
  final double step;
  final double newRating;

  @override
  List<Object?> get props => [r, pts, step, newRating];
}

/// `GET /rules` — fully server-driven.
final class Rules extends Equatable {
  const Rules({
    this.pointsTable = const [],
    this.examples = const [],
    this.walkExamples = const [],
  });

  final List<PointRow> pointsTable;
  final List<RuleExample> examples;
  final List<WalkExample> walkExamples;

  @override
  List<Object?> get props => [pointsTable, examples, walkExamples];
}
