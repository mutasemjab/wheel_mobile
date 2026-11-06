import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheel_mobile/core/entities/data_state.dart';
import 'package:wheel_mobile/core/entities/enums.dart';
import 'package:wheel_mobile/core/error/failures.dart';
import 'package:wheel_mobile/core/result/result.dart';
import 'package:wheel_mobile/features/matches/domain/entities/match.dart';
import 'package:wheel_mobile/features/matches/domain/usecases/get_matches.dart';
import 'package:wheel_mobile/features/matches/presentation/bloc/matches_bloc.dart';

class _MockGetMatches extends Mock implements GetMatches {}

FootballMatch _m(String code) =>
    FootballMatch(code: code, opponent: 'X', result: MatchResult.win);

void main() {
  late _MockGetMatches getMatches;
  final page1 = MatchesPage(
    items: [_m('a'), _m('b')],
    currentPage: 1,
    lastPage: 2,
    total: 3,
  );
  final page2 = MatchesPage(
    items: [_m('c')],
    currentPage: 2,
    lastPage: 2,
    total: 3,
  );

  setUp(() {
    getMatches = _MockGetMatches();
    when(
      () => getMatches(fromCache: true),
    ).thenAnswer((_) async => const Err(CacheFailure()));
    when(() => getMatches()).thenAnswer((_) async => Success(page1));
    when(() => getMatches(page: 2)).thenAnswer((_) async => Success(page2));
  });

  blocTest<MatchesBloc, MatchesState>(
    'loads the first page',
    build: () => MatchesBloc(getMatches.call),
    act: (b) => b.add(const MatchesStarted()),
    expect: () => [
      const MatchesState(status: DataStatus.loading),
      MatchesState(
        status: DataStatus.loaded,
        items: page1.items,
        page: 1,
        lastPage: 2,
      ),
    ],
  );

  blocTest<MatchesBloc, MatchesState>(
    'load more appends the next page',
    build: () => MatchesBloc(getMatches.call),
    seed: () => MatchesState(
      status: DataStatus.loaded,
      items: page1.items,
      page: 1,
      lastPage: 2,
    ),
    act: (b) => b.add(const MatchesNextPageRequested()),
    expect: () => [
      MatchesState(
        status: DataStatus.loaded,
        items: page1.items,
        page: 1,
        lastPage: 2,
        loadingMore: true,
      ),
      MatchesState(
        status: DataStatus.loaded,
        items: [...page1.items, ...page2.items],
        page: 2,
        lastPage: 2,
      ),
    ],
  );

  blocTest<MatchesBloc, MatchesState>(
    'on the last page nothing more is requested',
    build: () => MatchesBloc(getMatches.call),
    seed: () => MatchesState(
      status: DataStatus.loaded,
      items: [...page1.items, ...page2.items],
      page: 2,
      lastPage: 2,
    ),
    act: (b) => b.add(const MatchesNextPageRequested()),
    expect: () => <MatchesState>[],
    verify: (_) => verifyNever(() => getMatches(page: 3)),
  );

  blocTest<MatchesBloc, MatchesState>(
    'refresh failure keeps the list',
    setUp: () => when(
      () => getMatches(),
    ).thenAnswer((_) async => const Err(NetworkFailure())),
    build: () => MatchesBloc(getMatches.call),
    seed: () => MatchesState(
      status: DataStatus.loaded,
      items: page1.items,
      page: 1,
      lastPage: 2,
    ),
    act: (b) => b.add(const MatchesRefreshed()),
    expect: () => [
      MatchesState(
        status: DataStatus.refreshing,
        items: page1.items,
        page: 1,
        lastPage: 2,
      ),
      MatchesState(
        status: DataStatus.loaded,
        items: page1.items,
        page: 1,
        lastPage: 2,
        failure: const NetworkFailure(),
      ),
    ],
  );
}
