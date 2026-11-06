import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../entities/data_state.dart';
import '../result/result.dart';

/// Base cubit for read-only viewer screens.
///
/// * [load] shows the cached copy instantly (if any), then fetches.
/// * [refresh] keeps the current data visible while refetching.
/// * A [refreshTrigger] (e.g. `VersionPoller.dataChanges`) refreshes silently.
abstract class DataCubit<T> extends Cubit<DataState<T>> {
  DataCubit({Stream<void>? refreshTrigger}) : super(DataState<T>()) {
    _trigger = refreshTrigger?.listen((_) => refresh());
  }

  StreamSubscription<void>? _trigger;

  /// Fetches data; [fromCache] reads only the local copy.
  Future<Result<T>> fetch({required bool fromCache});

  Future<void> load() async {
    if (state.hasData) return refresh();
    emit(state.copyWith(status: DataStatus.loading, clearFailure: true));
    final cached = await fetch(fromCache: true);
    if (isClosed) return;
    if (cached case Success(:final value)) {
      emit(
        DataState<T>(
          status: DataStatus.refreshing,
          data: value,
          fromCache: true,
        ),
      );
    }
    await _fetchRemote();
  }

  Future<void> refresh() async {
    if (state.status == DataStatus.loading) return;
    emit(
      state.copyWith(
        status: state.hasData ? DataStatus.refreshing : DataStatus.loading,
        clearFailure: true,
      ),
    );
    await _fetchRemote();
  }

  Future<void> _fetchRemote() async {
    final result = await fetch(fromCache: false);
    if (isClosed) return;
    switch (result) {
      case Success(:final value):
        emit(DataState<T>(status: DataStatus.loaded, data: value));
      case Err(:final failure):
        emit(
          state.copyWith(
            status: state.hasData ? DataStatus.loaded : DataStatus.failure,
            failure: failure,
          ),
        );
    }
  }

  @override
  Future<void> close() async {
    await _trigger?.cancel();
    return super.close();
  }
}
