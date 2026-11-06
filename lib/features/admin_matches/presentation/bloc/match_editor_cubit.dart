import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/entities/enums.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../../live_desk/domain/entities/live_match_rules.dart';
import '../../../live_desk/domain/entities/live_match_state.dart';
import '../../../players/domain/usecases/get_players.dart';
import '../../domain/usecases/get_match_for_edit.dart';
import '../../domain/usecases/update_finished_match.dart';

enum EditorStatus { loading, ready, saving, saved, failure }

final class MatchEditorState extends Equatable {
  const MatchEditorState({
    this.status = EditorStatus.loading,
    this.match,
    this.note = '',
    this.names = const {},
    this.failure,
  });

  final EditorStatus status;
  final LiveMatchState? match;
  final String note;
  final Map<String, String> names;
  final Failure? failure;

  String nameOf(String slug) => names[slug] ?? slug;

  MatchEditorState copyWith({
    EditorStatus? status,
    LiveMatchState? match,
    String? note,
    Map<String, String>? names,
    Failure? failure,
  }) => MatchEditorState(
    status: status ?? this.status,
    match: match ?? this.match,
    note: note ?? this.note,
    names: names ?? this.names,
    failure: failure,
  );

  @override
  List<Object?> get props => [status, match, note, names, failure];
}

/// Edits a finished match with the live-desk rules, saved via
/// `PUT /admin/matches/{code}`.
class MatchEditorCubit extends Cubit<MatchEditorState> {
  MatchEditorCubit(
    this._getForEdit,
    this._update,
    this._getPlayers,
    this.code, {
    required String Function() newId,
    Future<void> Function()? onSaved,
  }) : _newId = newId,
       _onSaved = onSaved,
       super(const MatchEditorState());

  final GetMatchForEdit _getForEdit;
  final UpdateFinishedMatch _update;
  final GetPlayers _getPlayers;
  final String code;
  final String Function() _newId;
  final Future<void> Function()? _onSaved;

  Future<void> load() async {
    emit(state.copyWith(status: EditorStatus.loading));
    final (result, directory) = await (
      _getForEdit(code),
      _getPlayers.directory(),
    ).wait;
    switch (result) {
      case Success(:final value):
        emit(
          MatchEditorState(
            status: EditorStatus.ready,
            match: value.match,
            note: value.note,
            names: directory.map((k, v) => MapEntry(k, v.name)),
          ),
        );
      case Err(:final failure):
        emit(state.copyWith(status: EditorStatus.failure, failure: failure));
    }
  }

  void _apply(LiveMatchState Function(LiveMatchState m) change) {
    final match = state.match;
    if (match == null || state.status == EditorStatus.saving) return;
    emit(state.copyWith(status: EditorStatus.ready, match: change(match)));
  }

  void setOpponent(String value) => _apply((m) => m.copyWith(opponent: value));

  void setDate(DateTime date) => _apply(
    (m) => m.copyWith(date: DateTime(date.year, date.month, date.day)),
  );

  void setNote(String value) => emit(state.copyWith(note: value));

  void addEvent(LiveEventType type, {String? player, String? assist}) => _apply(
    (m) => m.addEvent(
      LiveEvent(uuid: _newId(), type: type, player: player, assist: assist),
    ),
  );

  void editEvent(LiveEvent event) => _apply((m) => m.updateEvent(event));

  void removeEvent(String uuid) => _apply((m) => m.removeEvent(uuid));

  void setMotm(String? slug) => _apply((m) => m.setMotm(slug));

  void changeValues(String slug, int delta) =>
      _apply((m) => m.changeValues(slug, delta));

  void toggleUnfair(String slug) => _apply((m) => m.toggleUnfair(slug));

  void toggleLate(String slug) => _apply((m) => m.toggleLate(slug));

  void addEmergencyPlayer(String slug) =>
      _apply((m) => m.addEmergencyPlayer(slug));

  Future<void> save() async {
    final match = state.match;
    if (match == null) return;
    emit(state.copyWith(status: EditorStatus.saving));
    final note = state.note.trim();
    final result = await _update(
      match.sanitized(),
      note: note.isEmpty ? null : note,
    );
    switch (result) {
      case Success():
        await _onSaved?.call();
        emit(state.copyWith(status: EditorStatus.saved));
      case Err(:final failure):
        emit(state.copyWith(status: EditorStatus.ready, failure: failure));
    }
  }
}
