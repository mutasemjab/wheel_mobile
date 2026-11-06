import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheel_mobile/core/entities/data_state.dart';
import 'package:wheel_mobile/core/error/failures.dart';
import 'package:wheel_mobile/core/result/result.dart';
import 'package:wheel_mobile/features/home/domain/entities/home_data.dart';
import 'package:wheel_mobile/features/home/domain/usecases/get_home.dart';
import 'package:wheel_mobile/features/home/presentation/bloc/home_cubit.dart';
import 'package:wheel_mobile/features/team/domain/entities/team.dart';

class _MockGetHome extends Mock implements GetHome {}

const _cached = HomeData(team: TeamInfo(name: 'cached'), version: 21);
const _fresh = HomeData(team: TeamInfo(name: 'WHEEL FC'), version: 22);

void main() {
  late _MockGetHome getHome;

  setUp(() => getHome = _MockGetHome());

  void stub({Result<HomeData>? cache, Result<HomeData>? remote}) {
    when(
      () => getHome(fromCache: true),
    ).thenAnswer((_) async => cache ?? const Err(CacheFailure()));
    when(
      () => getHome(fromCache: false),
    ).thenAnswer((_) async => remote ?? const Success(_fresh));
  }

  blocTest<HomeCubit, DataState<HomeData>>(
    'loading → loaded when nothing is cached',
    setUp: stub,
    build: () => HomeCubit(getHome),
    act: (c) => c.load(),
    expect: () => [
      const DataState<HomeData>(status: DataStatus.loading),
      const DataState<HomeData>(status: DataStatus.loaded, data: _fresh),
    ],
  );

  blocTest<HomeCubit, DataState<HomeData>>(
    'shows the cached copy first, then the fresh data',
    setUp: () => stub(cache: const Success(_cached)),
    build: () => HomeCubit(getHome),
    act: (c) => c.load(),
    expect: () => [
      const DataState<HomeData>(status: DataStatus.loading),
      const DataState<HomeData>(
        status: DataStatus.refreshing,
        data: _cached,
        fromCache: true,
      ),
      const DataState<HomeData>(status: DataStatus.loaded, data: _fresh),
    ],
  );

  blocTest<HomeCubit, DataState<HomeData>>(
    'refresh keeps the old data visible',
    setUp: stub,
    build: () => HomeCubit(getHome),
    seed: () => const DataState(status: DataStatus.loaded, data: _cached),
    act: (c) => c.refresh(),
    expect: () => [
      const DataState<HomeData>(status: DataStatus.refreshing, data: _cached),
      const DataState<HomeData>(status: DataStatus.loaded, data: _fresh),
    ],
  );

  blocTest<HomeCubit, DataState<HomeData>>(
    'failure without data → failure state',
    setUp: () => stub(remote: const Err(NetworkFailure())),
    build: () => HomeCubit(getHome),
    act: (c) => c.load(),
    expect: () => [
      const DataState<HomeData>(status: DataStatus.loading),
      const DataState<HomeData>(
        status: DataStatus.failure,
        failure: NetworkFailure(),
      ),
    ],
  );

  blocTest<HomeCubit, DataState<HomeData>>(
    'failure while refreshing keeps data and reports the failure',
    setUp: () => stub(remote: const Err(ServerFailure())),
    build: () => HomeCubit(getHome),
    seed: () => const DataState(status: DataStatus.loaded, data: _cached),
    act: (c) => c.refresh(),
    expect: () => [
      const DataState<HomeData>(status: DataStatus.refreshing, data: _cached),
      const DataState<HomeData>(
        status: DataStatus.loaded,
        data: _cached,
        failure: ServerFailure(),
      ),
    ],
  );

  test('a version change triggers a silent refresh', () async {
    stub();
    final trigger = StreamController<void>();
    final cubit = HomeCubit(getHome, refreshTrigger: trigger.stream);
    trigger.add(null);
    await expectLater(
      cubit.stream,
      emitsThrough(
        const DataState<HomeData>(status: DataStatus.loaded, data: _fresh),
      ),
    );
    await cubit.close();
    await trigger.close();
  });
}
