import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/admin_matches/presentation/bloc/admin_match_actions_cubit.dart';
import '../features/admin_matches/presentation/bloc/match_editor_cubit.dart';
import '../features/admin_matches/presentation/pages/admin_match_detail_page.dart';
import '../features/admin_matches/presentation/pages/admin_matches_page.dart';
import '../features/admin_matches/presentation/pages/match_editor_page.dart';
import '../features/admin_players/domain/entities/admin_player.dart';
import '../features/admin_players/presentation/bloc/admin_players_cubit.dart';
import '../features/admin_players/presentation/bloc/player_form_cubit.dart';
import '../features/admin_players/presentation/pages/admin_players_page.dart';
import '../features/admin_players/presentation/pages/player_form_page.dart';
import '../features/admin_settings/presentation/bloc/settings_cubit.dart';
import '../features/admin_settings/presentation/pages/settings_page.dart';
import '../features/auth/domain/entities/admin_user.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/pages/admin_home_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/compare/presentation/bloc/compare_cubit.dart';
import '../features/compare/presentation/pages/compare_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/leaderboards/presentation/pages/stats_page.dart';
import '../features/live_desk/presentation/bloc/live_desk_bloc.dart';
import '../features/live_desk/presentation/pages/live_desk_page.dart';
import '../features/live_viewer/presentation/bloc/live_viewer_cubit.dart';
import '../features/live_viewer/presentation/pages/live_viewer_page.dart';
import '../features/matches/presentation/bloc/match_detail_cubit.dart';
import '../features/matches/presentation/bloc/matches_bloc.dart';
import '../features/matches/presentation/pages/match_detail_page.dart';
import '../features/matches/presentation/pages/matches_page.dart';
import '../features/more/presentation/pages/more_page.dart';
import '../features/news/presentation/bloc/post_detail_cubit.dart';
import '../features/news/presentation/pages/news_page.dart';
import '../features/news/presentation/pages/post_detail_page.dart';
import '../features/players/presentation/bloc/player_profile_cubit.dart';
import '../features/players/presentation/pages/player_profile_page.dart';
import '../features/rules/presentation/bloc/rules_cubit.dart';
import '../features/rules/presentation/pages/rules_page.dart';
import '../features/standings/presentation/pages/standings_page.dart';
import '../features/team/presentation/bloc/team_cubit.dart';
import '../features/team/presentation/pages/team_page.dart';
import 'di.dart';
import 'routes.dart';
import 'shell.dart';

/// Lets go_router re-run redirects when the auth state changes.
class _StreamListenable extends ChangeNotifier {
  _StreamListenable(Stream<Object?> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<Object?> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

GoRouter buildRouter(AuthBloc auth) {
  final parentKey = GlobalKey<NavigatorState>();
  AdminUser? user() => auth.state.user;

  /// Admin routes need a session and the right permission.
  String? guard(GoRouterState s) {
    final path = s.matchedLocation;
    final u = user();
    if (path == AppRoutes.login) return u == null ? null : AppRoutes.admin;
    if (!path.startsWith(AppRoutes.admin)) return null;
    if (u == null) return AppRoutes.login;
    final allowed = switch (path) {
      _ when path.startsWith(AppRoutes.liveDesk) => u.canManageLive,
      _ when path.startsWith(AppRoutes.adminMatches) => u.canEditMatches,
      _ when path.startsWith(AppRoutes.adminPlayers) => u.canManagePlayers,
      _ when path.startsWith(AppRoutes.adminSettings) => u.canEditConfig,
      _ => true,
    };
    return allowed ? null : AppRoutes.admin;
  }

  Widget provide<B extends StateStreamableSource<Object?>>(
    B Function() create,
    Widget child,
  ) => BlocProvider<B>(create: (_) => create(), child: child);

  return GoRouter(
    navigatorKey: parentKey,
    initialLocation: AppRoutes.home,
    refreshListenable: _StreamListenable(auth.stream),
    redirect: (_, state) => guard(state),
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (_, _) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.news,
                builder: (_, _) => const NewsPage(),
                routes: [
                  GoRoute(
                    path: ':slug',
                    parentNavigatorKey: parentKey,
                    builder: (_, s) => provide(
                      () =>
                          sl<PostDetailCubit>(param1: s.pathParameters['slug'])
                            ..load(),
                      const PostDetailPage(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.matches,
                builder: (_, _) => const MatchesPage(),
                routes: [
                  GoRoute(
                    path: ':code',
                    parentNavigatorKey: parentKey,
                    builder: (_, s) => provide(
                      () =>
                          sl<MatchDetailCubit>(param1: s.pathParameters['code'])
                            ..load(),
                      const MatchDetailPage(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.stats,
                builder: (_, _) => const StatsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.more,
                builder: (_, _) => const MorePage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/players/:slug',
        builder: (_, s) => provide(
          () =>
              sl<PlayerProfileCubit>(param1: s.pathParameters['slug'])..load(),
          const PlayerProfilePage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.live,
        builder: (_, _) => provide(
          () => sl<LiveViewerCubit>()..start(),
          const LiveViewerPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.standings,
        builder: (_, _) => const StandingsPage(),
      ),
      GoRoute(
        path: AppRoutes.compare,
        builder: (_, _) =>
            provide(() => sl<CompareCubit>()..load(), const ComparePage()),
      ),
      GoRoute(
        path: AppRoutes.team,
        builder: (_, _) =>
            provide(() => sl<TeamCubit>()..load(), const TeamPage()),
      ),
      GoRoute(
        path: AppRoutes.rules,
        builder: (_, _) =>
            provide(() => sl<RulesCubit>()..load(), const RulesPage()),
      ),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginPage()),
      GoRoute(
        path: AppRoutes.admin,
        builder: (_, _) => const AdminHomePage(),
        routes: [
          GoRoute(
            path: 'live',
            builder: (_, _) => provide(
              () => sl<LiveDeskBloc>()..add(const LiveDeskOpened()),
              const LiveDeskPage(),
            ),
          ),
          GoRoute(
            path: 'matches',
            builder: (_, _) => provide(
              () =>
                  sl<MatchesBloc>(instanceName: adminMatchesBloc)
                    ..add(const MatchesStarted()),
              const AdminMatchesPage(),
            ),
            routes: [
              GoRoute(
                path: ':code',
                builder: (_, s) {
                  final code = s.pathParameters['code']!;
                  final u = user();
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (_) =>
                            sl<MatchDetailCubit>(param1: code)..load(),
                      ),
                      BlocProvider(
                        create: (_) => sl<AdminMatchActionsCubit>(param1: code),
                      ),
                    ],
                    child: AdminMatchDetailPage(
                      canEdit: u?.can(Permissions.matchesUpdate) ?? false,
                      canDelete: u?.can(Permissions.matchesDelete) ?? false,
                    ),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (_, s) => provide(
                      () =>
                          sl<MatchEditorCubit>(param1: s.pathParameters['code'])
                            ..load(),
                      const MatchEditorPage(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: 'players',
            builder: (_, _) {
              final u = user();
              return provide(
                () => sl<AdminPlayersCubit>()..load(),
                AdminPlayersPage(
                  canCreate: u?.can(Permissions.playersCreate) ?? false,
                  canUpdate: u?.can(Permissions.playersUpdate) ?? false,
                  canDelete: u?.can(Permissions.playersDelete) ?? false,
                ),
              );
            },
            routes: [
              GoRoute(
                path: 'new',
                builder: (_, _) => provide(
                  () => sl<PlayerFormCubit>(),
                  const PlayerFormPage(),
                ),
              ),
              GoRoute(
                path: ':slug/edit',
                redirect: (_, s) =>
                    s.extra is AdminPlayer ? null : AppRoutes.adminPlayers,
                builder: (_, s) => provide(
                  () => sl<PlayerFormCubit>(param1: s.extra as AdminPlayer?),
                  const PlayerFormPage(),
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'settings',
            builder: (_, _) => provide(
              () => sl<SettingsCubit>()..load(),
              const SettingsPage(),
            ),
          ),
        ],
      ),
    ],
  );
}
