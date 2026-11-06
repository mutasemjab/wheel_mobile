import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/settings.dart';
import '../../domain/usecases/export_backup.dart';
import '../../domain/usecases/get_rating_config.dart';
import '../../domain/usecases/get_team_settings.dart';
import '../../domain/usecases/recompute_ratings.dart';
import '../../domain/usecases/save_rating_config.dart';
import '../../domain/usecases/save_team_settings.dart';

enum SettingsStatus { loading, ready, saving, failure }

/// One-shot outcome shown as a SnackBar.
sealed class SettingsNotice extends Equatable {
  const SettingsNotice();

  @override
  List<Object?> get props => [];
}

final class SettingsSaved extends SettingsNotice {
  const SettingsSaved();
}

final class SettingsRecomputed extends SettingsNotice {
  const SettingsRecomputed(this.version);

  final int version;

  @override
  List<Object?> get props => [version];
}

/// Backup JSON ready to be shared as a file.
final class SettingsBackupReady extends SettingsNotice {
  const SettingsBackupReady(this.json);

  final String json;

  @override
  List<Object?> get props => [json];
}

final class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.loading,
    this.config,
    this.team = const TeamSettings(),
    this.invalidFields = const {},
    this.failure,
    this.notice,
  });

  final SettingsStatus status;
  final RatingConfig? config;
  final TeamSettings team;

  /// `section.key` of text fields that are not numbers.
  final Set<String> invalidFields;
  final Failure? failure;
  final SettingsNotice? notice;

  Set<ConfigError> get configErrors =>
      config == null ? const {} : RatingConfigValidator.validate(config!);

  bool get canSaveConfig =>
      config != null && invalidFields.isEmpty && configErrors.isEmpty;

  SettingsState copyWith({
    SettingsStatus? status,
    RatingConfig? config,
    TeamSettings? team,
    Set<String>? invalidFields,
    Failure? failure,
    SettingsNotice? notice,
  }) => SettingsState(
    status: status ?? this.status,
    config: config ?? this.config,
    team: team ?? this.team,
    invalidFields: invalidFields ?? this.invalidFields,
    failure: failure,
    notice: notice,
  );

  @override
  List<Object?> get props => [
    status,
    config,
    team,
    invalidFields,
    failure,
    notice,
  ];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required GetRatingConfig getConfig,
    required SaveRatingConfig saveConfig,
    required GetTeamSettings getTeam,
    required SaveTeamSettings saveTeam,
    required RecomputeRatings recompute,
    required ExportBackup exportBackup,
    Future<void> Function()? onChanged,
  }) : _getConfig = getConfig,
       _saveConfig = saveConfig,
       _getTeam = getTeam,
       _saveTeam = saveTeam,
       _recompute = recompute,
       _exportBackup = exportBackup,
       _onChanged = onChanged,
       super(const SettingsState());

  final GetRatingConfig _getConfig;
  final SaveRatingConfig _saveConfig;
  final GetTeamSettings _getTeam;
  final SaveTeamSettings _saveTeam;
  final RecomputeRatings _recompute;
  final ExportBackup _exportBackup;
  final Future<void> Function()? _onChanged;

  static String fieldId(ConfigSection section, String key) =>
      '${section.apiKey}.$key';

  Future<void> load() async {
    emit(state.copyWith(status: SettingsStatus.loading));
    final (config, team) = await (_getConfig(), _getTeam()).wait;
    switch ((config, team)) {
      case (Success(value: final c), Success(value: final t)):
        emit(SettingsState(status: SettingsStatus.ready, config: c, team: t));
      case (Err(:final failure), _) || (_, Err(:final failure)):
        emit(state.copyWith(status: SettingsStatus.failure, failure: failure));
    }
  }

  void setValue(ConfigSection section, String key, String raw) {
    final config = state.config;
    if (config == null) return;
    final id = fieldId(section, key);
    final parsed = double.tryParse(raw.trim());
    final invalid = {...state.invalidFields};
    if (parsed == null) {
      emit(state.copyWith(invalidFields: invalid..add(id)));
      return;
    }
    emit(
      state.copyWith(
        config: config.withValue(section, key, parsed),
        invalidFields: invalid..remove(id),
      ),
    );
  }

  void setTeam(TeamSettings team) => emit(state.copyWith(team: team));

  Future<void> saveConfig() async {
    final config = state.config;
    if (config == null || !state.canSaveConfig) return;
    await _run(() => _saveConfig(config), const SettingsSaved());
  }

  Future<void> saveTeam() =>
      _run(() => _saveTeam(state.team), const SettingsSaved());

  Future<void> exportBackup() async {
    emit(state.copyWith(status: SettingsStatus.saving));
    final result = await _exportBackup();
    emit(switch (result) {
      Success(:final value) => state.copyWith(
        status: SettingsStatus.ready,
        notice: SettingsBackupReady(value),
      ),
      Err(:final failure) => state.copyWith(
        status: SettingsStatus.ready,
        failure: failure,
      ),
    });
  }

  Future<void> recompute() async {
    emit(state.copyWith(status: SettingsStatus.saving));
    final result = await _recompute();
    switch (result) {
      case Success(:final value):
        await _onChanged?.call();
        emit(
          state.copyWith(
            status: SettingsStatus.ready,
            notice: SettingsRecomputed(value),
          ),
        );
      case Err(:final failure):
        emit(state.copyWith(status: SettingsStatus.ready, failure: failure));
    }
  }

  Future<void> _run(
    Future<Result<void>> Function() action,
    SettingsNotice notice,
  ) async {
    emit(state.copyWith(status: SettingsStatus.saving));
    final result = await action();
    switch (result) {
      case Success():
        await _onChanged?.call();
        emit(state.copyWith(status: SettingsStatus.ready, notice: notice));
      case Err(:final failure):
        emit(state.copyWith(status: SettingsStatus.ready, failure: failure));
    }
  }
}
