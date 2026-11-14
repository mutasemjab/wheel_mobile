import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/routes.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../home/presentation/bloc/home_cubit.dart';

/// "المزيد": standings, player comparison, team, rules, live, public site,
/// admin entry, about.
class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final loggedIn = context.watch<AuthBloc>().state is AuthAuthenticated;
    final siteUrl = context.select<HomeCubit, String?>(
      (c) => c.state.data?.team.publicSiteUrl,
    );
    Widget tile(IconData icon, String label, VoidCallback onTap) => Card(
      child: ListTile(leading: Icon(icon), title: Text(label), onTap: onTap),
    );
    const gap = SizedBox(height: AppSpacing.sm);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.moreTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const Center(child: AppLogo(height: 72)),
          const SizedBox(height: AppSpacing.lg),
          tile(
            Icons.leaderboard_rounded,
            l10n.navStandings,
            () => context.push(AppRoutes.standings),
          ),
          gap,
          tile(
            Icons.compare_arrows_rounded,
            l10n.compareTitle,
            () => context.push(AppRoutes.compare),
          ),
          gap,
          tile(
            Icons.shield_rounded,
            l10n.teamInfo,
            () => context.push(AppRoutes.team),
          ),
          gap,
          tile(
            Icons.rule_rounded,
            l10n.rulesTitle,
            () => context.push(AppRoutes.rules),
          ),
          gap,
          tile(
            Icons.sensors_rounded,
            l10n.liveTitle,
            () => context.push(AppRoutes.live),
          ),
          if (siteUrl != null) ...[
            gap,
            tile(
              Icons.public_rounded,
              l10n.publicSite,
              () => launchUrl(
                Uri.parse(siteUrl),
                mode: LaunchMode.externalApplication,
              ),
            ),
          ],
          gap,
          tile(
            Icons.admin_panel_settings_rounded,
            loggedIn ? l10n.adminPanel : l10n.adminLogin,
            () => context.push(loggedIn ? AppRoutes.admin : AppRoutes.login),
          ),
          gap,
          tile(
            Icons.info_outline_rounded,
            l10n.about,
            () => showAboutDialog(
              context: context,
              applicationName: l10n.appTitle,
              applicationIcon: const AppLogo(height: 48),
              children: [Text(l10n.aboutText)],
            ),
          ),
        ],
      ),
    );
  }
}
