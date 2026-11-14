import 'package:equatable/equatable.dart';

enum FixtureStatus {
  scheduled,
  postponed,
  cancelled;

  static FixtureStatus parse(String? value) => FixtureStatus.values.firstWhere(
    (s) => s.name == value,
    orElse: () => scheduled,
  );
}

/// A scheduled match from `GET /fixtures`.
final class Fixture extends Equatable {
  const Fixture({
    required this.id,
    required this.opponent,
    required this.kickoffAt,
    required this.date,
    required this.time,
    this.status = FixtureStatus.scheduled,
    this.statusLabel = '',
    this.competition,
    this.location,
    this.mapUrl,
    this.notes,
    this.isUpcoming = false,
  });

  final int id;
  final String opponent;

  /// Exact instant (for the countdown).
  final DateTime kickoffAt;

  /// Local Amman date `YYYY-MM-DD` and time `HH:mm` as sent by the server.
  final String date;
  final String time;
  final FixtureStatus status;
  final String statusLabel;
  final String? competition;
  final String? location;
  final String? mapUrl;
  final String? notes;
  final bool isUpcoming;

  /// Where "open in maps" goes: the admin's link, else a search for [location].
  Uri? get mapsUri {
    if (mapUrl != null) return Uri.tryParse(mapUrl!);
    if (location == null) return null;
    return Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': location!,
    });
  }

  @override
  List<Object?> get props => [
    id,
    opponent,
    kickoffAt,
    date,
    time,
    status,
    statusLabel,
    competition,
    location,
    mapUrl,
    notes,
    isUpcoming,
  ];
}

final class FixturesData extends Equatable {
  const FixturesData({this.upcoming = const [], this.recent = const []});

  final List<Fixture> upcoming;
  final List<Fixture> recent;

  bool get isEmpty => upcoming.isEmpty && recent.isEmpty;

  @override
  List<Object?> get props => [upcoming, recent];
}
