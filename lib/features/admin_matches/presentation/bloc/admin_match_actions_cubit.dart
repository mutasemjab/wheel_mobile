import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/usecases/delete_finished_match.dart';
import '../../domain/usecases/get_match_summary_text.dart';

enum MatchActionStatus { idle, loadingSummary, deleting, deleted }

final class AdminMatchActionsState extends Equatable {
  const AdminMatchActionsState({
    this.status = MatchActionStatus.idle,
    this.summary,
    this.failure,
  });

  final MatchActionStatus status;
  final String? summary;
  final Failure? failure;

  @override
  List<Object?> get props => [status, summary, failure];
}

/// WhatsApp summary + delete for one finished match.
class AdminMatchActionsCubit extends Cubit<AdminMatchActionsState> {
  AdminMatchActionsCubit(
    this._getSummary,
    this._delete,
    this.code, {
    Future<void> Function()? onChanged,
  }) : _onChanged = onChanged,
       super(const AdminMatchActionsState());

  final GetMatchSummaryText _getSummary;
  final DeleteFinishedMatch _delete;
  final Future<void> Function()? _onChanged;
  final String code;

  Future<void> loadSummary() async {
    emit(
      AdminMatchActionsState(
        status: MatchActionStatus.loadingSummary,
        summary: state.summary,
      ),
    );
    final result = await _getSummary(code);
    emit(switch (result) {
      Success(:final value) => AdminMatchActionsState(summary: value),
      Err(:final failure) => AdminMatchActionsState(
        summary: state.summary,
        failure: failure,
      ),
    });
  }

  Future<void> delete() async {
    emit(
      AdminMatchActionsState(
        status: MatchActionStatus.deleting,
        summary: state.summary,
      ),
    );
    final result = await _delete(code);
    if (result case Err(:final failure)) {
      emit(AdminMatchActionsState(summary: state.summary, failure: failure));
      return;
    }
    await _onChanged?.call();
    emit(const AdminMatchActionsState(status: MatchActionStatus.deleted));
  }
}
