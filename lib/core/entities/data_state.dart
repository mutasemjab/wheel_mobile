import 'package:equatable/equatable.dart';

import '../error/failures.dart';

enum DataStatus { initial, loading, loaded, refreshing, failure }

/// Screen state that keeps the previous [data] while refreshing or failing,
/// so pull-to-refresh and silent refreshes never blank the screen.
final class DataState<T> extends Equatable {
  const DataState({
    this.status = DataStatus.initial,
    this.data,
    this.failure,
    this.fromCache = false,
  });

  final DataStatus status;
  final T? data;
  final Failure? failure;

  /// True while [data] came from the offline cache and is not yet refreshed.
  final bool fromCache;

  bool get hasData => data != null;
  bool get isBusy =>
      status == DataStatus.loading || status == DataStatus.refreshing;

  DataState<T> copyWith({
    DataStatus? status,
    T? data,
    Failure? failure,
    bool clearFailure = false,
    bool? fromCache,
  }) => DataState<T>(
    status: status ?? this.status,
    data: data ?? this.data,
    failure: clearFailure ? null : failure ?? this.failure,
    fromCache: fromCache ?? this.fromCache,
  );

  @override
  List<Object?> get props => [status, data, failure, fromCache];
}
