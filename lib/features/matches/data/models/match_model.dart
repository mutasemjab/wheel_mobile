import '../../../../core/entities/enums.dart';
import '../../../../core/utils/json_parsing.dart';
import '../../domain/entities/match.dart';

class MatchModel {
  const MatchModel({
    required this.code,
    this.date,
    required this.opponent,
    required this.scoreUs,
    required this.scoreThem,
    this.res,
    required this.played,
    required this.goals,
    required this.saves,
    required this.tackles,
    required this.og,
    required this.caused,
    required this.late,
    required this.excused,
    required this.unfair,
    required this.values,
    this.motm,
    this.note,
    this.ratings = const [],
  });

  factory MatchModel.fromJson(Json json) {
    final score = asList(json['score']);
    return MatchModel(
      code: asString(json['code']),
      date: parseMatchDateOrNull(json['date']),
      opponent: asString(json['opponent']),
      scoreUs: score.isNotEmpty ? asInt(score[0]) : 0,
      scoreThem: score.length > 1 ? asInt(score[1]) : 0,
      res: asNonEmptyStringOrNull(json['res']),
      played: [
        for (final p in asMapList(json['played']))
          if (asNonEmptyStringOrNull(p['slug']) != null)
            PlayerRef(slug: asString(p['slug']), name: asString(p['name'])),
      ],
      goals: [
        for (final g in asMapList(json['goals']))
          if (asNonEmptyStringOrNull(g['by']) != null)
            MatchGoal(
              by: asString(g['by']),
              assist: asNonEmptyStringOrNull(g['assist']),
              minute: asIntOrNull(g['minute']),
            ),
      ],
      saves: asIntMap(json['saves']),
      tackles: asIntMap(json['tackles']),
      og: asInt(json['og']),
      caused: asIntMap(json['caused']),
      late: asStringList(json['late']),
      excused: asStringList(json['excused']),
      unfair: asStringList(json['unfair']),
      values: asIntMap(json['values']),
      motm: asNonEmptyStringOrNull(json['motm']),
      note: asNonEmptyStringOrNull(json['note']),
      ratings: [
        for (final r in asMapList(json['ratings']))
          MatchRating(
            slug: asString(r['slug']),
            name: asString(r['name']),
            pts: asDouble(r['pts']),
            need: asDouble(r['need']),
            before: asDouble(r['before']),
            after: asDouble(r['after']),
            delta: asDouble(r['delta']),
            late: asBool(r['late']),
            excused: asBool(r['excused']),
            star: asBool(r['star']),
          ),
      ],
    );
  }

  final String code;
  final DateTime? date;
  final String opponent;
  final int scoreUs;
  final int scoreThem;
  final String? res;
  final List<PlayerRef> played;
  final List<MatchGoal> goals;
  final Map<String, int> saves;
  final Map<String, int> tackles;
  final int og;
  final Map<String, int> caused;
  final List<String> late;
  final List<String> excused;
  final List<String> unfair;
  final Map<String, int> values;
  final String? motm;
  final String? note;
  final List<MatchRating> ratings;

  FootballMatch toEntity() => FootballMatch(
    code: code,
    date: date,
    opponent: opponent,
    scoreUs: scoreUs,
    scoreThem: scoreThem,
    result:
        MatchResult.tryParse(res) ?? MatchResult.fromScore(scoreUs, scoreThem),
    played: played,
    goals: goals,
    saves: saves,
    tackles: tackles,
    og: og,
    caused: caused,
    late: late,
    excused: excused,
    unfair: unfair,
    values: values,
    motm: motm,
    note: note,
    ratings: ratings,
  );
}

class MatchesPageModel {
  const MatchesPageModel({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory MatchesPageModel.fromJson(dynamic body) {
    final meta = asMap(body is Map ? body['meta'] : null);
    final items = asMapList(dataOf(body)).map(MatchModel.fromJson).toList();
    final current = asInt(meta['current_page'], fallback: 1);
    return MatchesPageModel(
      items: items,
      currentPage: current,
      lastPage: asInt(meta['last_page'], fallback: current),
      total: asInt(meta['total'], fallback: items.length),
    );
  }

  final List<MatchModel> items;
  final int currentPage;
  final int lastPage;
  final int total;

  MatchesPage toEntity() => MatchesPage(
    items: items.map((m) => m.toEntity()).toList(growable: false),
    currentPage: currentPage,
    lastPage: lastPage,
    total: total,
  );
}
