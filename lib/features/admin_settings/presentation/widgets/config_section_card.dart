import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/number_format.dart';
import '../../../../core/widgets/section_card.dart';
import '../../domain/entities/settings.dart';
import '../bloc/settings_cubit.dart';

String configSectionTitle(BuildContext context, ConfigSection section) =>
    switch (section) {
      ConfigSection.points => context.l10n.pointsSection,
      ConfigSection.start => context.l10n.startSection,
      ConfigSection.bounds => context.l10n.boundsSection,
      ConfigSection.bands => context.l10n.bandsSection,
      ConfigSection.move => context.l10n.moveSection,
    };

/// Numeric fields for one config section; keys come from the server.
class ConfigSectionCard extends StatelessWidget {
  const ConfigSectionCard({
    super.key,
    required this.section,
    required this.values,
    required this.invalidFields,
    this.error,
  });

  static const double _fieldWidth = 150;

  final ConfigSection section;
  final Map<String, double> values;
  final Set<String> invalidFields;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    return SectionCard(
      title: configSectionTitle(context, section),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final entry in values.entries)
                SizedBox(
                  width: _fieldWidth,
                  child: TextFormField(
                    key: ValueKey('${section.apiKey}.${entry.key}'),
                    initialValue: NumberFormatX.compact(entry.value),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    textDirection: TextDirection.ltr,
                    decoration: InputDecoration(
                      labelText: entry.key,
                      errorText:
                          invalidFields.contains(
                            SettingsCubit.fieldId(section, entry.key),
                          )
                          ? context.l10n.invalidNumberField
                          : null,
                    ),
                    onChanged: (v) => cubit.setValue(section, entry.key, v),
                  ),
                ),
            ],
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(
                error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
    );
  }
}
