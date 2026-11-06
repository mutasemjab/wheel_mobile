import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import '../core/l10n/app_localizations.dart';
import '../core/network/network_status.dart';
import '../core/polling/version_poller.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/awards/presentation/bloc/awards_cubit.dart';
import '../features/home/presentation/bloc/home_cubit.dart';
import '../features/leaderboards/presentation/bloc/leaderboards_cubit.dart';
import '../features/matches/presentation/bloc/matches_bloc.dart';
import '../features/standings/presentation/bloc/standings_cubit.dart';
import 'di.dart';
import 'router.dart';

/// Root widget: theme, RTL Arabic localization, router, app-wide blocs.
/// Tab blocs live here so switching tabs keeps their state.
class WheelApp extends StatefulWidget {
  const WheelApp({super.key});

  @override
  State<WheelApp> createState() => _WheelAppState();
}

class _WheelAppState extends State<WheelApp> {
  static const Locale _arabic = Locale('ar');

  late final AuthBloc _auth;
  late final GoRouter _router;
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _auth = sl<AuthBloc>()..add(const AuthStarted());
    _router = buildRouter(_auth);
    // Poll `/version` only while in the foreground; poll immediately on resume.
    final poller = sl<VersionPoller>()..start();
    _lifecycle = AppLifecycleListener(
      onResume: poller.resume,
      onPause: poller.pause,
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider.value(value: _auth),
      BlocProvider.value(value: sl<NetworkStatusCubit>()),
      BlocProvider(create: (_) => sl<HomeCubit>()..load()),
      BlocProvider(create: (_) => sl<StandingsCubit>()..load()),
      BlocProvider(
        create: (_) => sl<MatchesBloc>()..add(const MatchesStarted()),
      ),
      BlocProvider(create: (_) => sl<LeaderboardsCubit>()..load()),
      BlocProvider(create: (_) => sl<AwardsCubit>()..load()),
    ],
    child: MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      locale: _arabic,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: _router,
    ),
  );
}
