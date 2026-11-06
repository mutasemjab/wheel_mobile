import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/admin_player.dart';
import '../../domain/usecases/create_player.dart';
import '../../domain/usecases/update_player.dart';
import '../../domain/usecases/upload_player_photo.dart';

enum PlayerFormStatus { editing, saving, saved, uploading }

final class PlayerFormState extends Equatable {
  const PlayerFormState({
    required this.draft,
    this.status = PlayerFormStatus.editing,
    this.localErrors = const {},
    this.failure,
    this.photoUploaded = false,
  });

  final PlayerDraft draft;
  final PlayerFormStatus status;
  final Map<String, PlayerFieldError> localErrors;
  final Failure? failure;
  final bool photoUploaded;

  /// Server error for [field] (422 `errors`).
  String? serverError(String field) {
    final f = failure;
    return f is ValidationFailure ? f.fieldError(field) : null;
  }

  PlayerFormState copyWith({
    PlayerDraft? draft,
    PlayerFormStatus? status,
    Map<String, PlayerFieldError>? localErrors,
    Failure? failure,
    bool clearFailure = false,
    bool? photoUploaded,
  }) => PlayerFormState(
    draft: draft ?? this.draft,
    status: status ?? this.status,
    localErrors: localErrors ?? this.localErrors,
    failure: clearFailure ? null : failure ?? this.failure,
    photoUploaded: photoUploaded ?? this.photoUploaded,
  );

  @override
  List<Object?> get props => [
    draft,
    status,
    localErrors,
    failure,
    photoUploaded,
  ];
}

/// Create (when [editingSlug] is null) or edit a player.
class PlayerFormCubit extends Cubit<PlayerFormState> {
  PlayerFormCubit(
    this._create,
    this._update,
    this._uploadPhoto, {
    AdminPlayer? player,
    Future<void> Function()? onSaved,
  }) : editingSlug = player?.slug,
       _onSaved = onSaved,
       super(PlayerFormState(draft: player?.toDraft() ?? const PlayerDraft()));

  final CreatePlayer _create;
  final UpdatePlayer _update;
  final UploadPlayerPhoto _uploadPhoto;
  final Future<void> Function()? _onSaved;
  final String? editingSlug;

  bool get isEditing => editingSlug != null;

  void change(PlayerDraft draft) => emit(
    state.copyWith(draft: draft, localErrors: const {}, clearFailure: true),
  );

  Future<void> save() async {
    final errors = PlayerDraftValidator.validate(state.draft);
    if (errors.isNotEmpty) {
      emit(state.copyWith(localErrors: errors));
      return;
    }
    emit(state.copyWith(status: PlayerFormStatus.saving, clearFailure: true));
    final slug = editingSlug;
    final result = slug == null
        ? await _create(state.draft)
        : await _update(slug, state.draft);
    switch (result) {
      case Success():
        await _onSaved?.call();
        emit(state.copyWith(status: PlayerFormStatus.saved));
      case Err(:final failure):
        emit(
          state.copyWith(status: PlayerFormStatus.editing, failure: failure),
        );
    }
  }

  Future<void> uploadPhoto(String filePath) async {
    final slug = editingSlug;
    if (slug == null) return;
    emit(
      state.copyWith(status: PlayerFormStatus.uploading, clearFailure: true),
    );
    final result = await _uploadPhoto(slug, filePath);
    switch (result) {
      case Success():
        await _onSaved?.call();
        emit(
          state.copyWith(status: PlayerFormStatus.editing, photoUploaded: true),
        );
      case Err(:final failure):
        emit(
          state.copyWith(status: PlayerFormStatus.editing, failure: failure),
        );
    }
  }
}
