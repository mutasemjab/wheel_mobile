import '../../../../core/bloc/data_cubit.dart';
import '../../../../core/entities/data_state.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/admin_player.dart';
import '../../domain/usecases/delete_player.dart';
import '../../domain/usecases/get_admin_players.dart';
import '../../domain/usecases/reorder_players.dart';

/// Player list with drag-and-drop reorder and delete.
class AdminPlayersCubit extends DataCubit<List<AdminPlayer>> {
  AdminPlayersCubit(
    this._getPlayers,
    this._reorder,
    this._delete, {
    Future<void> Function()? onChanged,
  }) : _onChanged = onChanged;

  final GetAdminPlayers _getPlayers;
  final ReorderPlayers _reorder;
  final DeletePlayer _delete;
  final Future<void> Function()? _onChanged;

  @override
  Future<Result<List<AdminPlayer>>> fetch({required bool fromCache}) async =>
      fromCache ? const Err(CacheFailure()) : _getPlayers();

  /// Optimistic reorder; reverts when the server rejects it.
  Future<void> move(int oldIndex, int newIndex) async {
    final players = state.data;
    if (players == null) return;
    final previous = [...players];
    final target = newIndex > oldIndex ? newIndex - 1 : newIndex;
    final reordered = [...players];
    final moved = reordered.removeAt(oldIndex);
    reordered.insert(target, moved);
    emit(DataState(status: DataStatus.loaded, data: reordered));
    final result = await _reorder([for (final p in reordered) p.slug]);
    if (result case Err(:final failure)) {
      emit(
        DataState(status: DataStatus.loaded, data: previous, failure: failure),
      );
      return;
    }
    await _onChanged?.call();
  }

  Future<void> delete(String slug) async {
    final result = await _delete(slug);
    if (result case Err(:final failure)) {
      emit(state.copyWith(failure: failure));
      return;
    }
    await _onChanged?.call();
    await refresh();
  }
}
