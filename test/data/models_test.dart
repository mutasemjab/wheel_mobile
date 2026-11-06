import 'package:flutter_test/flutter_test.dart';
import 'package:wheel_mobile/core/entities/enums.dart';
import 'package:wheel_mobile/core/models/clock_snapshot_model.dart';
import 'package:wheel_mobile/core/network/api_config.dart';
import 'package:wheel_mobile/core/polling/version_poller.dart';
import 'package:wheel_mobile/core/utils/json_parsing.dart';
import 'package:wheel_mobile/core/utils/number_format.dart';
import 'package:wheel_mobile/features/admin_matches/data/models/editable_match_model.dart';
import 'package:wheel_mobile/features/admin_settings/data/models/settings_model.dart';
import 'package:wheel_mobile/features/admin_settings/domain/entities/settings.dart';
import 'package:wheel_mobile/features/auth/data/models/admin_user_model.dart';
import 'package:wheel_mobile/features/auth/domain/entities/admin_user.dart';
import 'package:wheel_mobile/features/awards/data/models/award_model.dart';
import 'package:wheel_mobile/features/home/data/models/home_model.dart';
import 'package:wheel_mobile/features/leaderboards/data/models/leaderboards_model.dart';
import 'package:wheel_mobile/features/leaderboards/domain/entities/leaderboards.dart';
import 'package:wheel_mobile/features/live_desk/data/models/server_live_match_model.dart';
import 'package:wheel_mobile/features/live_desk/domain/entities/live_match_state.dart';
import 'package:wheel_mobile/features/live_viewer/data/models/live_match_model.dart';
import 'package:wheel_mobile/features/matches/data/models/match_model.dart';
import 'package:wheel_mobile/features/players/data/models/player_model.dart';
import 'package:wheel_mobile/features/players/data/models/player_profile_model.dart';
import 'package:wheel_mobile/features/rules/data/models/rules_model.dart';
import 'package:wheel_mobile/features/standings/data/models/standings_model.dart';
import 'package:wheel_mobile/features/team/data/models/team_model.dart';

import '../helpers/fixtures.dart';

void main() {
  const config = ApiConfig('http://10.0.2.2/wheel/api/v1');

  test('ApiConfig derives the storage base from API_BASE_URL', () {
    expect(config.storageBase, 'http://10.0.2.2/wheel/storage');
    expect(
      config.storageUrl('team/crest.png'),
      'http://10.0.2.2/wheel/storage/team/crest.png',
    );
    expect(config.storageUrl(null), isNull);
  });

  test('version', () {
    final v = AppVersion.fromJson(fixtureData('version'));
    expect(v.version, 22);
    expect(v.liveUpdatedAt, '2026-10-31T10:19:26.000000Z');
  });

  test('home', () {
    final home = HomeModel.fromJson(fixtureData('home')).toEntity();
    expect(home.team.name, 'WHEEL FC');
    expect(
      home.team.crestUrl,
      'http://localhost/wheel/storage/team/crest.png',
      reason: 'absolute crest_url used as-is',
    );
    expect(home.team.groupPhotoUrl, isNull);
    expect(home.updated, DateTime(2026, 10, 30));
    expect(home.tiers.map((t) => t.tier), [Tier.a, Tier.b, Tier.c]);
    final tierA = home.tiers.first;
    expect((tierA.labelEn, tierA.min, tierA.max), ('Elite', 80, 99));
    final hassan = tierA.players.single;
    expect(hassan.ratingExact, 81.5);
    expect(hassan.moved, Movement.up);
    expect(hassan.number, 9, reason: 'no merge with /players any more');
    expect(hassan.photoUrl, endsWith('hassan.jpg'));
    expect(hassan.isGoalkeeper, isFalse);
    expect((hassan.tierNow, hassan.tierPrev), (Tier.a, Tier.b));
    final live = home.live!;
    expect(live.opponent, 'رجائي');
    expect((live.scoreUs, live.scoreThem), (2, 1));
    expect(live.updatedAt, isNotNull);
    expect(home.awards.single.key, 'top_rated');
    expect(home.awards.single.player?.slug, 'hassan');
    expect(home.record.gf, 2);
  });

  test('players list (stats may be an empty list)', () {
    final players = fixtureList(
      'players',
    ).map((j) => PlayerModel.fromJson(j).toEntity()).toList();
    expect(players, hasLength(3));
    expect(players.first.number, 20);
    expect(players.first.nameEn, isNull);
    expect(players[1].tierPrev, Tier.b);
    expect(players[2].isGoalkeeper, isTrue);
    expect(players[2].ratingExact, 31.0);
    expect(players[2].stats.mp, 0);
  });

  test('player profile', () {
    final p = PlayerProfileModel.fromJson(
      fixtureData('player_profile'),
    ).toEntity();
    expect(p.player.slug, 'basel');
    expect(p.history.single.result, MatchResult.win);
    expect(p.history.single.scoreUs, 2);
    expect(p.history.single.delta, 1.8);
    expect(p.ratingChart.map((c) => c.value), [30, 31.8]);
    expect(p.insights.single.icon, 'ℹ️');
    expect(p.nextTarget, 3);
    expect(p.gapToNextTier, isNull);
  });

  test('standings', () {
    final s = StandingsModel.fromJson(fixtureData('standings')).toEntity();
    expect(s.tiers, hasLength(3));
    expect(s.tiers.first.labelEn, 'Elite');
    expect((s.tiers.last.min, s.tiers.last.max), (10, 39));
    expect(s.allPlayers, hasLength(3));
  });

  test('awards: stable key, 2-decimal values, open award', () {
    final awards = AwardModel.listFromJson(
      dataOf(fixtureBody('awards')),
    ).map((a) => a.toEntity()).toList();
    expect(awards.map((a) => a.key), ['top_rated', 'the_rocket', 'the_wall']);
    expect(NumberFormatX.upTo2(awards[1].value!), '1.25');
    expect(NumberFormatX.upTo2(awards[0].value!), '81.5');
    expect(NumberFormatX.upTo2(3), '3');
    expect(awards[2].player, isNull);
    expect(awards[2].value, isNull);
  });

  test('award key falls back to `en` for old cached responses', () {
    final a = AwardModel.fromJson(const {'en': 'RANK 1', 'ar': 'x'}).toEntity();
    expect(a.key, 'RANK 1');
  });

  test('leaderboards', () {
    final l = LeaderboardsModel.fromJson(
      fixtureData('leaderboards'),
    ).toEntity();
    expect(l.boards[BoardKind.goals]!.single.name, 'حسن');
    expect(l.boards[BoardKind.saves], isEmpty);
    expect(l.averages.appsPerPlayer, 0.3);
    expect(l.goalsChart.single.them, 1);
  });

  test('team', () {
    final t = TeamOverviewModel.fromJson(fixtureData('team')).toEntity();
    expect(t.winPct, 100);
    expect(t.last5, [MatchResult.loss, MatchResult.win]);
    expect(t.insights, hasLength(1));
    expect(t.info.crestUrl, isNull);
  });

  test('rules', () {
    final r = RulesModel.fromJson(fixtureData('rules')).toEntity();
    expect(r.pointsTable.last.value, -5);
    expect(r.examples.single.parts, hasLength(2));
    expect(r.walkExamples.single.newRating, 36);
  });

  test('matches page with meta', () {
    final page = MatchesPageModel.fromJson(fixtureBody('matches')).toEntity();
    expect(page.lastPage, 2);
    expect(page.hasMore, isTrue);
    final m = page.items.single;
    expect(m.scoreUs, 2);
    expect(m.result, MatchResult.win);
    expect(m.caused, {'basel': 1});
    expect(m.goals.single.assist, 'sameh');
    expect(m.ratings, isEmpty, reason: 'ratings only on the detail');
  });

  test('match detail: {} maps and ratings', () {
    final m = MatchModel.fromJson(fixtureData('match')).toEntity();
    expect(m.saves, isEmpty);
    expect(m.values, isEmpty);
    expect(m.caused, isEmpty);
    expect(m.note, 'مباراة حلوة');
    expect(m.everyonePlayed, isFalse);
    expect(m.ratings, hasLength(2));
    final hassan = m.ratings.first;
    expect((hassan.pts, hassan.before, hassan.after), (13, 80, 81.5));
    expect(hassan.delta, 1.5);
    expect(hassan.star, isTrue);
    expect(m.ratings.last.excused, isTrue);
  });

  test('asIntMap still tolerates [] and "" keys from old cached data', () {
    final m = MatchModel.fromJson({
      ...fixtureData('match'),
      'saves': <Object>[],
      'caused': {'': 1, 'basel': 2},
    }).toEntity();
    expect(m.saves, isEmpty);
    expect(m.caused, {'basel': 2});
  });

  test('live (public)', () {
    final live = LiveMatchModel.fromJson(fixtureData('live')).toEntity();
    expect(live.scoreUs, 2);
    expect(live.clock.accMs, 437);
    expect(live.clock.runAtMs, isNull);
    expect(live.clock.serverNowMs, 1793441966448);
    expect(live.events.first.type, LiveEventType.og);
    expect(live.playerStats['hassan']?.g, 1);
  });

  test('admin live: events sorted oldest → newest', () {
    final s = ServerLiveMatchModel(fixtureData('admin_live')).toEntity();
    expect(s.clock.accMs, 0);
    expect(s.clock.serverNowMs, 1793441966448);
    expect(s.events.map((e) => e.uuid), ['u1', 'u5']);
    final local = s.toLocal();
    expect(local.played, ['sameh', 'hassan']);
    expect(local.excused, ['musa']);
    expect(local.unfair, {'sameh'});
    expect(local.late, {'hassan'});
    expect(local.values, {'hassan': 2});
    expect(local.scoreUs, 2);
    expect(local.serverCreated, isTrue);
  });

  test('sync response: admin live state, server time, divergence report', () {
    final s = ServerLiveMatchModel(
      asMap(dataOf(fixtureBody('live_sync'))),
    ).toEntity();
    expect(s.events.map((e) => e.uuid), ['e1', 'e2']);
    expect(s.clock.serverNowMs, 1793441966448);
    expect(s.clock.runAtMs, 1793441919000);
    final local = s.toLocal();
    expect(s.differencesFrom(local), isEmpty);
    final mine = local.copyWith(
      events: [
        ...local.events,
        const LiveEvent(uuid: 'e9', type: LiveEventType.save, player: 'a'),
      ],
    );
    expect(s.differencesFrom(mine), [contains('e9')]);
  });

  test('clock reply carries server time', () {
    final c = ClockSnapshotModel.fromJson(
      dataOf(fixtureBody('live_clock')),
    ).toEntity();
    expect(
      (c.accMs, c.runAtMs, c.serverNowMs),
      (437, 1793441966000, 1793441966448),
    );
  });

  test('publish reply is the public match object', () {
    final m = MatchModel.fromJson(
      asMap(dataOf(fixtureBody('live_publish'))),
    ).toEntity();
    expect(m.code, 'm-20261030-abc123');
    expect((m.scoreUs, m.scoreThem), (2, 1));
    expect(m.motm, 'hassan');
  });

  test('admin match editor shape', () {
    final e = EditableMatchModel(fixtureData('admin_match_edit')).toEntity();
    expect(e.status, 'finished');
    expect(e.note, 'مباراة حلوة');
    expect(e.match.played, ['sameh', 'hassan']);
    expect(e.match.excused, ['musa']);
    expect(e.match.values, {'sameh': 1});
    expect(e.match.events.map((x) => x.uuid), ['e1', 'e2', 'e3']);
    expect((e.match.scoreUs, e.match.scoreThem), (2, 1));
  });

  test('finish summary starts with the real score', () {
    final f = LiveFinishResultModel(fixtureData('finish')).toEntity();
    expect(f.scoreUs, 2);
    expect(f.motm, 'hassan');
    expect(f.summary, startsWith('WHEEL FC 2–1'));
  });

  test('auth login carries permissions; /me', () {
    final login = LoginResponseModel.fromJson(fixtureData('login'));
    expect(login.token, '1|abcdef');
    expect(login.user.roles, ['match_admin']);
    final pinUser = login.user.toEntity();
    expect(pinUser.canManageLive, isTrue);
    expect(pinUser.can(Permissions.matchesUpdate), isTrue);
    expect(pinUser.canEditConfig, isFalse);
    final me = AdminUserModel.fromJson(fixtureData('me')).toEntity();
    expect(me.canManageLive, isTrue);
    expect(me.canEditConfig, isTrue);
    expect(me.canManagePlayers, isFalse);
  });

  test('rating config keeps unknown members and drops tiers on save', () {
    final c = RatingConfigModel(fixtureData('config')).toEntity();
    expect(c.value(ConfigSection.points, 'excused'), -5);
    expect(c.value(ConfigSection.move, 'perPoint'), 0.6);
    final body = RatingConfigModel.body(c);
    expect(body.containsKey('tiers'), isFalse);
    expect(body['matchFixes'], isNotNull);
    expect((body['bands'] as Map)['A'], 80);
  });
}
