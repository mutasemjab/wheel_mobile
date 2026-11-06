import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/settings.dart';
import '../bloc/settings_cubit.dart';
import '../widgets/config_section_card.dart';
import '../widgets/team_settings_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static String? _sectionError(
    BuildContext context,
    ConfigSection s,
    Set<ConfigError> errors,
  ) {
    final l10n = context.l10n;
    final messages = [
      if (s == ConfigSection.bands && errors.contains(ConfigError.bands))
        l10n.errBands,
      if (s == ConfigSection.bounds && errors.contains(ConfigError.bounds))
        l10n.errBounds,
      if (s == ConfigSection.move && errors.contains(ConfigError.brakeBottom))
        l10n.errBrakeBottom,
      if (s == ConfigSection.move && errors.contains(ConfigError.brakeTop))
        l10n.errBrakeTop,
    ];
    return messages.isEmpty ? null : messages.join('\n');
  }

  static const String _jsonMime = 'application/json';

  /// Shares the `/admin/export` JSON as a `.json` file.
  static Future<void> _shareBackup(String json) async {
    final name = 'wheel-fc-backup-${DateUtilsX.compact(DateTime.now())}.json';
    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile.fromData(utf8.encode(json), name: name, mimeType: _jsonMime),
        ],
        fileNameOverrides: [name],
      ),
    );
  }

  Future<void> _saveConfig(BuildContext context) async {
    final cubit = context.read<SettingsCubit>();
    final ok = await confirmDialog(
      context,
      message: context.l10n.recomputeWarning,
    );
    if (ok) await cubit.saveConfig();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<SettingsCubit, SettingsState>(
      listenWhen: (p, n) => n.failure != p.failure || n.notice != p.notice,
      listener: (context, state) {
        if (state.failure != null && state.config != null) {
          showFailureSnack(context, state.failure!);
        }
        switch (state.notice) {
          case SettingsSaved():
            showMessageSnack(context, l10n.saved);
          case SettingsRecomputed(:final version):
            showMessageSnack(context, l10n.recomputeDone(version));
          case SettingsBackupReady(:final json):
            _shareBackup(json);
          case null:
            break;
        }
      },
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();
        final config = state.config;
        final busy = state.status == SettingsStatus.saving;
        return Scaffold(
          appBar: AppBar(title: Text(l10n.settings)),
          body: switch (state.status) {
            SettingsStatus.loading => const LoadingView(),
            SettingsStatus.failure when config == null => ErrorView(
              failure: state.failure!,
              onRetry: cubit.load,
            ),
            _ => ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Text(
                  l10n.ratingConfig,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                for (final section in ConfigSection.values)
                  if (config!.sections[section]?.isNotEmpty ?? false) ...[
                    ConfigSectionCard(
                      section: section,
                      values: config.sections[section]!,
                      invalidFields: state.invalidFields,
                      error: _sectionError(
                        context,
                        section,
                        state.configErrors,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                Text(
                  '⚠ ${l10n.recomputeWarning}',
                  style: const TextStyle(color: AppColors.warning),
                ),
                const SizedBox(height: AppSpacing.sm),
                FilledButton(
                  onPressed: busy || !state.canSaveConfig
                      ? null
                      : () => _saveConfig(context),
                  child: Text(l10n.save),
                ),
                const SizedBox(height: AppSpacing.xl),
                TeamSettingsCard(team: state.team, busy: busy),
                const SizedBox(height: AppSpacing.xl),
                OutlinedButton.icon(
                  onPressed: busy ? null : cubit.recompute,
                  icon: const Icon(Icons.calculate_rounded),
                  label: Text(l10n.recompute),
                ),
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton.icon(
                  onPressed: busy ? null : cubit.exportBackup,
                  icon: const Icon(Icons.backup_rounded),
                  label: Text(l10n.backup),
                ),
              ],
            ),
          },
        );
      },
    );
  }
}
