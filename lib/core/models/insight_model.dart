import '../entities/insight.dart';
import '../utils/json_parsing.dart';

class InsightModel {
  const InsightModel({required this.icon, required this.text});

  factory InsightModel.fromJson(Json json) =>
      InsightModel(icon: asString(json['icon']), text: asString(json['text']));

  static List<InsightModel> listFromJson(dynamic json) =>
      asMapList(json).map(InsightModel.fromJson).toList(growable: false);

  final String icon;
  final String text;

  Insight toEntity() => Insight(icon: icon, text: text);
}
