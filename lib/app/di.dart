import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../core/network/api_config.dart';
import '../core/network/cached_api.dart';
import '../core/network/connectivity_service.dart';
import '../core/network/dio_client.dart';
import '../core/network/interceptors/auth_interceptor.dart';
import '../core/network/network_status.dart';
import '../core/polling/version_poller.dart';
import '../core/storage/json_cache.dart';
import '../core/storage/secure_token_storage.dart';
import '../core/utils/device_name.dart';
import '../features/admin_matches/data/datasources/admin_matches_remote_data_source.dart';
import '../features/admin_matches/data/repositories/admin_matches_repository_impl.dart';
import '../features/admin_matches/domain/repositories/admin_matches_repository.dart';
import '../features/admin_matches/domain/usecases/delete_finished_match.dart';
import '../features/admin_matches/domain/usecases/get_admin_matches.dart';
import '../features/admin_matches/domain/usecases/get_match_for_edit.dart';
import '../features/admin_matches/domain/usecases/get_match_summary_text.dart';
import '../features/admin_matches/domain/usecases/update_finished_match.dart';
import '../features/admin_matches/presentation/bloc/admin_match_actions_cubit.dart';
import '../features/admin_matches/presentation/bloc/match_editor_cubit.dart';
import '../features/admin_players/data/datasources/admin_players_remote_data_source.dart';
import '../features/admin_players/data/repositories/admin_players_repository_impl.dart';
import '../features/admin_players/domain/entities/admin_player.dart';
import '../features/admin_players/domain/repositories/admin_players_repository.dart';
import '../features/admin_players/domain/usecases/create_player.dart';
import '../features/admin_players/domain/usecases/delete_player.dart';
import '../features/admin_players/domain/usecases/get_admin_players.dart';
import '../features/admin_players/domain/usecases/reorder_players.dart';
import '../features/admin_players/domain/usecases/update_player.dart';
import '../features/admin_players/domain/usecases/upload_player_photo.dart';
import '../features/admin_players/presentation/bloc/admin_players_cubit.dart';
import '../features/admin_players/presentation/bloc/player_form_cubit.dart';
import '../features/admin_settings/data/datasources/settings_remote_data_source.dart';
import '../features/admin_settings/data/repositories/settings_repository_impl.dart';
import '../features/admin_settings/domain/repositories/settings_repository.dart';
import '../features/admin_settings/domain/usecases/export_backup.dart';
import '../features/admin_settings/domain/usecases/get_rating_config.dart';
import '../features/admin_settings/domain/usecases/get_team_settings.dart';
import '../features/admin_settings/domain/usecases/recompute_ratings.dart';
import '../features/admin_settings/domain/usecases/save_rating_config.dart';
import '../features/admin_settings/domain/usecases/save_team_settings.dart';
import '../features/admin_settings/presentation/bloc/settings_cubit.dart';
import '../features/auth/data/datasources/auth_local_data_source.dart';
import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_with_email.dart';
import '../features/auth/domain/usecases/login_with_pin.dart';
import '../features/auth/domain/usecases/logout.dart';
import '../features/auth/domain/usecases/restore_session.dart';
import '../features/auth/domain/usecases/watch_session_expired.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/awards/data/datasources/awards_remote_data_source.dart';
import '../features/awards/data/repositories/awards_repository_impl.dart';
import '../features/awards/domain/repositories/awards_repository.dart';
import '../features/awards/domain/usecases/get_awards.dart';
import '../features/awards/presentation/bloc/awards_cubit.dart';
import '../features/home/data/datasources/home_remote_data_source.dart';
import '../features/home/data/repositories/home_repository_impl.dart';
import '../features/home/domain/repositories/home_repository.dart';
import '../features/home/domain/usecases/get_home.dart';
import '../features/home/presentation/bloc/home_cubit.dart';
import '../features/leaderboards/data/datasources/leaderboards_remote_data_source.dart';
import '../features/leaderboards/data/repositories/leaderboards_repository_impl.dart';
import '../features/leaderboards/domain/repositories/leaderboards_repository.dart';
import '../features/leaderboards/domain/usecases/get_leaderboards.dart';
import '../features/leaderboards/presentation/bloc/leaderboards_cubit.dart';
import '../features/live_desk/data/datasources/live_desk_local_data_source.dart';
import '../features/live_desk/data/datasources/live_desk_remote_data_source.dart';
import '../features/live_desk/data/repositories/live_desk_repository_impl.dart';
import '../features/live_desk/domain/repositories/live_desk_repository.dart';
import '../features/live_desk/domain/usecases/clear_local_live_match.dart';
import '../features/live_desk/domain/usecases/discard_live_match.dart';
import '../features/live_desk/domain/usecases/finish_live_match.dart';
import '../features/live_desk/domain/usecases/get_server_live_match.dart';
import '../features/live_desk/domain/usecases/load_local_live_match.dart';
import '../features/live_desk/domain/usecases/publish_live_match.dart';
import '../features/live_desk/domain/usecases/save_local_live_match.dart';
import '../features/live_desk/domain/usecases/send_clock_hint.dart';
import '../features/live_desk/domain/usecases/sync_live_match.dart';
import '../features/live_desk/presentation/bloc/live_desk_bloc.dart';
import '../features/live_viewer/data/datasources/live_viewer_remote_data_source.dart';
import '../features/live_viewer/data/repositories/live_viewer_repository_impl.dart';
import '../features/live_viewer/domain/repositories/live_viewer_repository.dart';
import '../features/live_viewer/domain/usecases/get_live_match.dart';
import '../features/live_viewer/presentation/bloc/live_viewer_cubit.dart';
import '../features/matches/data/datasources/matches_remote_data_source.dart';
import '../features/matches/data/repositories/matches_repository_impl.dart';
import '../features/matches/domain/repositories/matches_repository.dart';
import '../features/matches/domain/usecases/get_match_detail.dart';
import '../features/matches/domain/usecases/get_matches.dart';
import '../features/matches/presentation/bloc/match_detail_cubit.dart';
import '../features/matches/presentation/bloc/matches_bloc.dart';
import '../features/players/data/datasources/players_remote_data_source.dart';
import '../features/players/data/repositories/players_repository_impl.dart';
import '../features/players/domain/repositories/players_repository.dart';
import '../features/players/domain/usecases/get_player_profile.dart';
import '../features/players/domain/usecases/get_players.dart';
import '../features/players/presentation/bloc/player_profile_cubit.dart';
import '../features/rules/data/datasources/rules_remote_data_source.dart';
import '../features/rules/data/repositories/rules_repository_impl.dart';
import '../features/rules/domain/repositories/rules_repository.dart';
import '../features/rules/domain/usecases/get_rules.dart';
import '../features/rules/presentation/bloc/rules_cubit.dart';
import '../features/standings/data/datasources/standings_remote_data_source.dart';
import '../features/standings/data/repositories/standings_repository_impl.dart';
import '../features/standings/domain/repositories/standings_repository.dart';
import '../features/standings/domain/usecases/get_standings.dart';
import '../features/standings/presentation/bloc/standings_cubit.dart';
import '../features/team/data/datasources/team_remote_data_source.dart';
import '../features/team/data/repositories/team_repository_impl.dart';
import '../features/team/domain/repositories/team_repository.dart';
import '../features/team/domain/usecases/get_team.dart';
import '../features/team/presentation/bloc/team_cubit.dart';

final GetIt sl = GetIt.instance;

/// Instance name of the [MatchesBloc] backed by `GET /admin/matches`.
const String adminMatchesBloc = 'adminMatches';

/// Registers every dependency. Call once from `main()`.
Future<void> configureDependencies({ApiConfig? config}) async {
  final prefs = await SharedPreferences.getInstance();
  _core(prefs, config ?? ApiConfig.fromEnvironment());
  _repositories(prefs);
  _useCases();
  _presentation();
}

void _core(SharedPreferences prefs, ApiConfig config) {
  sl
    ..registerSingleton<ApiConfig>(config)
    ..registerSingleton<SharedPreferences>(prefs)
    ..registerSingleton<Logger>(Logger())
    ..registerSingleton<TokenStorage>(SecureTokenStorage())
    ..registerSingleton<NetworkStatusCubit>(NetworkStatusCubit())
    ..registerSingleton<AuthInterceptor>(AuthInterceptor(sl()))
    ..registerSingleton<Dio>(
      DioClient.create(
        config: config,
        auth: sl(),
        networkStatus: sl(),
        logger: sl(),
      ),
    )
    ..registerSingleton<JsonCache>(JsonCache(prefs))
    ..registerSingleton<CachedApi>(CachedApi(sl(), sl()))
    ..registerSingleton<ConnectivityService>(ConnectivityPlusService())
    ..registerSingleton<VersionPoller>(
      VersionPoller(RemoteVersionSource(sl())),
    );
}

void _repositories(SharedPreferences prefs) {
  sl
    ..registerLazySingleton<PlayersRepository>(
      () => PlayersRepositoryImpl(PlayersRemoteDataSource(sl())),
    )
    ..registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(HomeRemoteDataSource(sl())),
    )
    ..registerLazySingleton<StandingsRepository>(
      () => StandingsRepositoryImpl(StandingsRemoteDataSource(sl())),
    )
    ..registerLazySingleton<MatchesRepository>(
      () => MatchesRepositoryImpl(MatchesRemoteDataSource(sl())),
    )
    ..registerLazySingleton<LeaderboardsRepository>(
      () => LeaderboardsRepositoryImpl(LeaderboardsRemoteDataSource(sl())),
    )
    ..registerLazySingleton<AwardsRepository>(
      () => AwardsRepositoryImpl(AwardsRemoteDataSource(sl())),
    )
    ..registerLazySingleton<TeamRepository>(
      () => TeamRepositoryImpl(TeamRemoteDataSource(sl())),
    )
    ..registerLazySingleton<RulesRepository>(
      () => RulesRepositoryImpl(RulesRemoteDataSource(sl())),
    )
    ..registerLazySingleton<LiveViewerRepository>(
      () => LiveViewerRepositoryImpl(LiveViewerRemoteDataSource(sl())),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remote: AuthRemoteDataSource(sl()),
        local: AuthLocalDataSource(sl(), prefs),
        deviceName: DeviceName.resolve,
        sessionExpired: sl<AuthInterceptor>().sessionExpired,
      ),
    )
    ..registerLazySingleton<LiveDeskRepository>(
      () => LiveDeskRepositoryImpl(
        LiveDeskRemoteDataSource(sl()),
        LiveDeskLocalDataSource(prefs),
      ),
    )
    ..registerLazySingleton<AdminMatchesRepository>(
      () => AdminMatchesRepositoryImpl(AdminMatchesRemoteDataSource(sl())),
    )
    ..registerLazySingleton<AdminPlayersRepository>(
      () =>
          AdminPlayersRepositoryImpl(AdminPlayersRemoteDataSource(sl()), sl()),
    )
    ..registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(SettingsRemoteDataSource(sl())),
    );
}

void _useCases() {
  sl
    ..registerLazySingleton(() => GetPlayers(sl()))
    ..registerLazySingleton(() => GetPlayerProfile(sl()))
    ..registerLazySingleton(() => GetHome(sl()))
    ..registerLazySingleton(() => GetStandings(sl()))
    ..registerLazySingleton(() => GetMatches(sl()))
    ..registerLazySingleton(() => GetMatchDetail(sl(), sl()))
    ..registerLazySingleton(() => GetLeaderboards(sl()))
    ..registerLazySingleton(() => GetAwards(sl()))
    ..registerLazySingleton(() => GetTeam(sl()))
    ..registerLazySingleton(() => GetRules(sl()))
    ..registerLazySingleton(() => GetLiveMatch(sl()))
    ..registerLazySingleton(() => LoginWithEmail(sl()))
    ..registerLazySingleton(() => LoginWithPin(sl()))
    ..registerLazySingleton(() => RestoreSession(sl()))
    ..registerLazySingleton(() => Logout(sl()))
    ..registerLazySingleton(() => WatchSessionExpired(sl()))
    ..registerLazySingleton(() => GetServerLiveMatch(sl()))
    ..registerLazySingleton(() => SyncLiveMatch(sl()))
    ..registerLazySingleton(() => SendClockHint(sl()))
    ..registerLazySingleton(() => FinishLiveMatch(sl()))
    ..registerLazySingleton(() => PublishLiveMatch(sl()))
    ..registerLazySingleton(() => DiscardLiveMatch(sl()))
    ..registerLazySingleton(() => LoadLocalLiveMatch(sl()))
    ..registerLazySingleton(() => SaveLocalLiveMatch(sl()))
    ..registerLazySingleton(() => ClearLocalLiveMatch(sl()))
    ..registerLazySingleton(() => GetAdminMatches(sl()))
    ..registerLazySingleton(() => GetMatchForEdit(sl()))
    ..registerLazySingleton(() => GetMatchSummaryText(sl()))
    ..registerLazySingleton(() => UpdateFinishedMatch(sl()))
    ..registerLazySingleton(() => DeleteFinishedMatch(sl()))
    ..registerLazySingleton(() => GetAdminPlayers(sl()))
    ..registerLazySingleton(() => CreatePlayer(sl()))
    ..registerLazySingleton(() => UpdatePlayer(sl()))
    ..registerLazySingleton(() => DeletePlayer(sl()))
    ..registerLazySingleton(() => UploadPlayerPhoto(sl()))
    ..registerLazySingleton(() => ReorderPlayers(sl()))
    ..registerLazySingleton(() => GetRatingConfig(sl()))
    ..registerLazySingleton(() => SaveRatingConfig(sl()))
    ..registerLazySingleton(() => GetTeamSettings(sl()))
    ..registerLazySingleton(() => SaveTeamSettings(sl()))
    ..registerLazySingleton(() => RecomputeRatings(sl()))
    ..registerLazySingleton(() => ExportBackup(sl()));
}

/// After an admin write: refresh every viewer screen now.
Future<void> _refreshPublicData() =>
    sl<VersionPoller>().pollNow(forceDataRefresh: true);

void _presentation() {
  final poller = sl<VersionPoller>();
  sl
    ..registerLazySingleton(
      () => AuthBloc(
        loginWithEmail: sl(),
        loginWithPin: sl(),
        restoreSession: sl(),
        logout: sl(),
        watchSessionExpired: sl(),
      ),
    )
    ..registerFactory(() => HomeCubit(sl(), refreshTrigger: poller.anyChanges))
    ..registerFactory(
      () => StandingsCubit(sl(), refreshTrigger: poller.dataChanges),
    )
    ..registerFactory(
      () => MatchesBloc(
        sl<GetMatches>().call,
        refreshTrigger: poller.dataChanges,
      ),
    )
    ..registerFactory(
      () => LeaderboardsCubit(sl(), refreshTrigger: poller.dataChanges),
    )
    ..registerFactory(
      () => AwardsCubit(sl(), refreshTrigger: poller.dataChanges),
    )
    ..registerFactory(() => TeamCubit(sl(), refreshTrigger: poller.dataChanges))
    ..registerFactory(
      () => RulesCubit(sl(), refreshTrigger: poller.dataChanges),
    )
    ..registerFactoryParam<PlayerProfileCubit, String, void>(
      (slug, _) =>
          PlayerProfileCubit(sl(), slug, refreshTrigger: poller.dataChanges),
    )
    ..registerFactoryParam<MatchDetailCubit, String, void>(
      (code, _) =>
          MatchDetailCubit(sl(), code, refreshTrigger: poller.dataChanges),
    )
    ..registerFactory(
      () => LiveViewerCubit(
        sl(),
        getPlayers: sl(),
        liveChanges: poller.liveChanges,
      ),
    )
    ..registerFactory(
      () => LiveDeskBloc(
        LiveDeskUseCases(
          getServerMatch: sl(),
          syncMatch: sl(),
          sendClock: sl(),
          finishMatch: sl(),
          publishMatch: sl(),
          discardMatch: sl(),
          loadLocal: sl(),
          saveLocal: sl(),
          clearLocal: sl(),
          getPlayers: sl(),
        ),
        connectivity: sl<ConnectivityService>().onlineChanges,
        onPublished: _refreshPublicData,
        onServerDiff: (message) => sl<Logger>().w(message),
      ),
    )
    ..registerFactory(
      () => MatchesBloc(sl<GetAdminMatches>().call),
      instanceName: adminMatchesBloc,
    )
    ..registerFactoryParam<AdminMatchActionsCubit, String, void>(
      (code, _) => AdminMatchActionsCubit(
        sl(),
        sl(),
        code,
        onChanged: _refreshPublicData,
      ),
    )
    ..registerFactoryParam<MatchEditorCubit, String, void>(
      (code, _) => MatchEditorCubit(
        sl(),
        sl(),
        sl(),
        code,
        newId: const Uuid().v4,
        onSaved: _refreshPublicData,
      ),
    )
    ..registerFactory(
      () => AdminPlayersCubit(sl(), sl(), sl(), onChanged: _refreshPublicData),
    )
    ..registerFactoryParam<PlayerFormCubit, AdminPlayer?, void>(
      (player, _) => PlayerFormCubit(
        sl(),
        sl(),
        sl(),
        player: player,
        onSaved: _refreshPublicData,
      ),
    )
    ..registerFactory(
      () => SettingsCubit(
        getConfig: sl(),
        saveConfig: sl(),
        getTeam: sl(),
        saveTeam: sl(),
        recompute: sl(),
        exportBackup: sl(),
        onChanged: _refreshPublicData,
      ),
    );
}
