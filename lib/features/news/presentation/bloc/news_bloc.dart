import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/entities/data_state.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/get_post_categories.dart';
import '../../domain/usecases/get_posts.dart';

sealed class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

/// First load (cache first, then network) of categories and page 1.
final class NewsStarted extends NewsEvent {
  const NewsStarted();
}

/// Pull-to-refresh / version change: reload page 1, keep items visible.
final class NewsRefreshed extends NewsEvent {
  const NewsRefreshed();
}

/// Filter by a category key; null shows every category.
final class NewsCategorySelected extends NewsEvent {
  const NewsCategorySelected(this.category);
  final String? category;

  @override
  List<Object?> get props => [category];
}

final class NewsNextPageRequested extends NewsEvent {
  const NewsNextPageRequested();
}

final class NewsState extends Equatable {
  const NewsState({
    this.status = DataStatus.initial,
    this.items = const [],
    this.categories = const [],
    this.category,
    this.page = 0,
    this.lastPage = 1,
    this.loadingMore = false,
    this.failure,
  });

  final DataStatus status;
  final List<PostSummary> items;
  final List<PostCategory> categories;

  /// Selected category key (null = all).
  final String? category;
  final int page;
  final int lastPage;
  final bool loadingMore;
  final Failure? failure;

  bool get hasMore => page < lastPage;
  bool get isBusy =>
      status == DataStatus.loading || status == DataStatus.refreshing;

  /// Categories worth showing as filter chips (hide empty ones).
  List<PostCategory> get visibleCategories =>
      categories.where((c) => (c.count ?? 1) > 0).toList(growable: false);

  NewsState copyWith({
    DataStatus? status,
    List<PostSummary>? items,
    List<PostCategory>? categories,
    String? Function()? category,
    int? page,
    int? lastPage,
    bool? loadingMore,
    Failure? failure,
    bool clearFailure = false,
  }) => NewsState(
    status: status ?? this.status,
    items: items ?? this.items,
    categories: categories ?? this.categories,
    category: category != null ? category() : this.category,
    page: page ?? this.page,
    lastPage: lastPage ?? this.lastPage,
    loadingMore: loadingMore ?? this.loadingMore,
    failure: clearFailure ? null : failure ?? this.failure,
  );

  @override
  List<Object?> get props => [
    status,
    items,
    categories,
    category,
    page,
    lastPage,
    loadingMore,
    failure,
  ];
}

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc(this._getPosts, this._getCategories, {Stream<void>? refreshTrigger})
    : super(const NewsState()) {
    on<NewsStarted>(_onStarted, transformer: droppable());
    on<NewsRefreshed>(_onRefreshed, transformer: restartable());
    on<NewsCategorySelected>(_onCategory, transformer: restartable());
    on<NewsNextPageRequested>(_onNextPage, transformer: droppable());
    _trigger = refreshTrigger?.listen((_) => add(const NewsRefreshed()));
  }

  final GetPosts _getPosts;
  final GetPostCategories _getCategories;
  StreamSubscription<void>? _trigger;

  Future<void> _onStarted(NewsStarted event, Emitter<NewsState> emit) async {
    if (state.items.isNotEmpty) {
      return _onRefreshed(const NewsRefreshed(), emit);
    }
    emit(state.copyWith(status: DataStatus.loading, clearFailure: true));
    final cachedCats = await _getCategories(fromCache: true);
    final cached = await _getPosts(category: state.category, fromCache: true);
    if (cached case Success(:final value)) {
      emit(
        _firstPage(
          value,
          DataStatus.refreshing,
        ).copyWith(categories: cachedCats.valueOrNull),
      );
    }
    await _loadFirstPage(emit, withCategories: true);
  }

  Future<void> _onRefreshed(
    NewsRefreshed event,
    Emitter<NewsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: state.items.isEmpty
            ? DataStatus.loading
            : DataStatus.refreshing,
        clearFailure: true,
      ),
    );
    await _loadFirstPage(emit, withCategories: true);
  }

  Future<void> _onCategory(
    NewsCategorySelected event,
    Emitter<NewsState> emit,
  ) async {
    if (event.category == state.category && state.items.isNotEmpty) return;
    emit(
      state.copyWith(
        category: () => event.category,
        items: const [],
        page: 0,
        lastPage: 1,
        status: DataStatus.loading,
        clearFailure: true,
      ),
    );
    final cached = await _getPosts(category: event.category, fromCache: true);
    if (cached case Success(:final value)) {
      emit(_firstPage(value, DataStatus.refreshing));
    }
    await _loadFirstPage(emit);
  }

  Future<void> _loadFirstPage(
    Emitter<NewsState> emit, {
    bool withCategories = false,
  }) async {
    final categories = withCategories ? _getCategories() : null;
    final result = await _getPosts(category: state.category);
    final cats = (await categories)?.valueOrNull;
    switch (result) {
      case Success(:final value):
        emit(_firstPage(value, DataStatus.loaded).copyWith(categories: cats));
      case Err(:final failure):
        emit(
          state.copyWith(
            status: state.items.isEmpty
                ? DataStatus.failure
                : DataStatus.loaded,
            categories: cats,
            failure: failure,
          ),
        );
    }
  }

  Future<void> _onNextPage(
    NewsNextPageRequested event,
    Emitter<NewsState> emit,
  ) async {
    if (!state.hasMore ||
        state.loadingMore ||
        state.status != DataStatus.loaded) {
      return;
    }
    emit(state.copyWith(loadingMore: true, clearFailure: true));
    final result = await _getPosts(
      page: state.page + 1,
      category: state.category,
    );
    switch (result) {
      case Success(:final value):
        final known = state.items.map((p) => p.slug).toSet();
        emit(
          state.copyWith(
            items: [
              ...state.items,
              ...value.items.where((p) => !known.contains(p.slug)),
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

  NewsState _firstPage(PostsPage page, DataStatus status) => state.copyWith(
    status: status,
    items: page.items,
    page: page.currentPage,
    lastPage: page.lastPage,
    loadingMore: false,
    clearFailure: true,
  );

  @override
  Future<void> close() async {
    await _trigger?.cancel();
    return super.close();
  }
}
