import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheel_mobile/core/entities/data_state.dart';
import 'package:wheel_mobile/core/error/failures.dart';
import 'package:wheel_mobile/core/result/result.dart';
import 'package:wheel_mobile/features/players/data/models/player_profile_model.dart';
import 'package:wheel_mobile/features/players/domain/entities/player_profile.dart';
import 'package:wheel_mobile/features/players/domain/usecases/get_player_profile.dart';
import 'package:wheel_mobile/features/players/presentation/bloc/player_profile_cubit.dart';

import '../../helpers/fixtures.dart';

class _MockGetProfile extends Mock implements GetPlayerProfile {}

void main() {
  late _MockGetProfile getProfile;
  final profile = PlayerProfileModel.fromJson(
    fixtureData('player_profile'),
  ).toEntity();

  setUp(() {
    getProfile = _MockGetProfile();
    when(
      () => getProfile('basel', fromCache: true),
    ).thenAnswer((_) async => const Err(CacheFailure()));
  });

  blocTest<PlayerProfileCubit, DataState<PlayerProfile>>(
    'loads the profile for its slug',
    setUp: () => when(
      () => getProfile('basel', fromCache: false),
    ).thenAnswer((_) async => Success(profile)),
    build: () => PlayerProfileCubit(getProfile, 'basel'),
    act: (c) => c.load(),
    expect: () => [
      const DataState<PlayerProfile>(status: DataStatus.loading),
      DataState<PlayerProfile>(status: DataStatus.loaded, data: profile),
    ],
    verify: (_) =>
        verify(() => getProfile('basel', fromCache: false)).called(1),
  );

  blocTest<PlayerProfileCubit, DataState<PlayerProfile>>(
    'unknown player → NotFound failure',
    setUp: () => when(
      () => getProfile('basel', fromCache: false),
    ).thenAnswer((_) async => const Err(NotFoundFailure())),
    build: () => PlayerProfileCubit(getProfile, 'basel'),
    act: (c) => c.load(),
    expect: () => [
      const DataState<PlayerProfile>(status: DataStatus.loading),
      const DataState<PlayerProfile>(
        status: DataStatus.failure,
        failure: NotFoundFailure(),
      ),
    ],
  );
}
