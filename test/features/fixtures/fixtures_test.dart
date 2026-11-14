import 'package:flutter_test/flutter_test.dart';
import 'package:wheel_mobile/core/utils/countdown.dart';
import 'package:wheel_mobile/features/fixtures/data/models/fixture_model.dart';
import 'package:wheel_mobile/features/fixtures/domain/entities/fixture.dart';

import '../../helpers/fixtures.dart';

void main() {
  test('fixtures: upcoming and recent lists', () {
    final data = FixtureModel.dataFromJson(fixtureData('fixtures'));

    expect(data.upcoming.map((f) => f.opponent), ['زيزيا', 'رجائي']);
    expect(data.recent, hasLength(1));
    final next = data.upcoming.first;
    expect(next.time, '20:00');
    expect(next.status, FixtureStatus.scheduled);
    expect(next.isUpcoming, isTrue);
    expect(next.kickoffAt.isUtc, isTrue);
    expect(data.recent.first.isUpcoming, isFalse);
  });

  test('maps link: admin URL first, else a search for the venue', () {
    Fixture f({String? location, String? mapUrl}) => Fixture(
      id: 1,
      opponent: 'X',
      kickoffAt: DateTime.utc(2026),
      date: '2026-01-01',
      time: '20:00',
      location: location,
      mapUrl: mapUrl,
    );

    expect(f().mapsUri, isNull);
    expect(
      f(location: 'ملعب', mapUrl: 'https://maps.app.goo.gl/x').mapsUri,
      Uri.parse('https://maps.app.goo.gl/x'),
    );
    final search = f(location: 'ملعب الحسين').mapsUri!;
    expect(search.host, 'www.google.com');
    expect(search.queryParameters['query'], 'ملعب الحسين');
  });

  test('unknown status falls back to scheduled', () {
    expect(FixtureStatus.parse('postponed'), FixtureStatus.postponed);
    expect(FixtureStatus.parse('weird'), FixtureStatus.scheduled);
    expect(FixtureStatus.parse(null), FixtureStatus.scheduled);
  });

  group('countdown', () {
    final now = DateTime.utc(2026, 11, 14, 12);

    test('past or now → started', () {
      expect(
        Countdown.until(now, now),
        const Countdown(CountdownUnit.started, 0),
      );
      expect(
        Countdown.until(now.subtract(const Duration(minutes: 5)), now).unit,
        CountdownUnit.started,
      );
    });

    test('under an hour → minutes (at least 1)', () {
      expect(
        Countdown.until(now.add(const Duration(seconds: 20)), now),
        const Countdown(CountdownUnit.minutes, 1),
      );
      expect(
        Countdown.until(now.add(const Duration(minutes: 45)), now),
        const Countdown(CountdownUnit.minutes, 45),
      );
    });

    test('under a day → hours, otherwise days', () {
      expect(
        Countdown.until(now.add(const Duration(hours: 5, minutes: 50)), now),
        const Countdown(CountdownUnit.hours, 5),
      );
      expect(
        Countdown.until(now.add(const Duration(days: 6, hours: 3)), now),
        const Countdown(CountdownUnit.days, 6),
      );
    });
  });
}
