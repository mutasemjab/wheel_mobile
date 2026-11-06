import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/entities/data_state.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/match.dart';

/// Loads one page (public `GetMatches` or the admin list).
typedef MatchesPageFetcher =
    Future<Result<MatchesPage>> Function({int page, bool fromCache});

sealed class MatchesEvent extends Equatable {
  const MatchesEvent();

  @override
  List<Object?> get props => [];
}

/// First page (cache first, then network).
final class MatchesStarted extends MatchesEvent {
  const MatchesStarted();
}

/// Pull-to-refresh / version change: reload page 1, keep items visible.
final class MatchesRefreshed extends MatchesEvent {
  const MatchesRefreshed();
}

final class MatchesNextPageRequested extends MatchesEvent {
  const MatchesNextPageRequested();
}

final class MatchesState extends Equatable {
  const MatchesState({
    this.status = DataStatus.initial,
    this.items = const [],
    this.page = 0,
    this.lastPage = 1,
    this.loadingMore = false,
    this.failure,
  });

  final DataStatus status;
  final List<FootballMatch> items;
  final int page;
  final int lastPage;
  final bool loadingMore;
  final Failure? failure;

  bool get hasMore => page < lastPage;

  MatchesState copyWith({
    DataStatus? status,
    List<FootballMatch>? items,
    int? page,
    int? lastPage,
    bool? loadingMore,
    Failure? failure,
    bool clearFailure = false,
  }) => MatchesState(
    status: status ?? this.status,
    items: items ?? this.items,
    page: page ?? this.page,
    lastPage: lastPage ?? this.lastPage,
    loadingMore: loadingMore ?? this.loadingMore,
    failure: clearFailure ? null : failure ?? this.failure,
  );

  @override
  List<Object?> get props => [
    status,
    items,
    page,
    lastPage,
    loadingMore,
    failure,
  ];
}

class MatchesBloc extends Bloc<MatchesEvent, MatchesState> {
  MatchesBloc(this._getMatches, {Stream<void>? refreshTrigger})
    : super(const MatchesState()) {
    on<MatchesStarted>(_onStarted, transformer: droppable());
    on<MatchesRefreshed>(_onRefreshed, transformer: restartable());
    on<MatchesNextPageRequested>(_onNextPage, transformer: droppable());
    _trigger = refreshTrigger?.listen((_) => add(const MatchesRefreshed()));
  }

  final MatchesPageFetcher _getMatches;
  StreamSubscription<void>? _trigger;

  Future<void> _onStarted(
    MatchesStarted event,
    Emitter<MatchesState> emit,
  ) async {
    if (state.items.isNotEmpty) {
      return _onRefreshed(const MatchesRefreshed(), emit);
    }
    emit(state.copyWith(status: DataStatus.loading, clearFailure: true));
    final cached = await _getMatches(fromCache: true);
    if (cached case Success(:final value)) {
      emit(_firstPage(value, DataStatus.refreshing));
    }
    await _loadFirstPage(emit);
  }

  Future<void> _onRefreshed(
    MatchesRefreshed event,
    Emitter<MatchesState> emit,
  ) async {
    emit(
      state.copyWith(
        status: state.items.isEmpty
            ? DataStatus.loading
            : DataStatus.refreshing,
        clearFailure: true,
      ),
    );
    await _loadFirstPage(emit);
  }

  Future<void> _loadFirstPage(Emitter<MatchesState> emit) async {
    final result = await _getMatches();
    switch (result) {
      case Success(:final value):
        emit(_firstPage(value, DataStatus.loaded));
      case Err(:final failure):
        emit(
          state.copyWith(
            status: state.items.isEmpty
                ? DataStatus.failure
                : DataStatus.loaded,
            failure: failure,
          ),
        );
    }
  }

  Future<void> _onNextPage(
    MatchesNextPageRequested event,
    Emitter<MatchesState> emit,
  ) async {
    if (!state.hasMore ||
        state.loadingMore ||
        state.status != DataStatus.loaded) {
      return;
    }
    emit(state.copyWith(loadingMore: true, clearFailure: true));
    final result = await _getMatches(page: state.page + 1);
    switch (result) {
      case Success(:final value):
        final known = state.items.map((m) => m.code).toSet();
        emit(
          state.copyWith(
            items: [
              ...state.items,
              ...value.items.where((m) => !known.contains(m.code)),
            ],
            page: value.currentPage,
            lastPage: value.lastPage,
            loadingMore: false,
          ),
        );
      case Err(:final failure):
        emit(state.copyWith(loadingMore: false, failure: failure));
    }
  }

  MatchesState _firstPage(MatchesPage page, DataStatus status) => MatchesState(
    status: status,
    items: page.items,
    page: page.currentPage,
    lastPage: page.lastPage,
  );

  @override
  Future<void> close() async {
    await _trigger?.cancel();
    return super.close();
  }
}
