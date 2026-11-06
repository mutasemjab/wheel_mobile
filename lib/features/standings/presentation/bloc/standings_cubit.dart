import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/bloc/data_cubit.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/standings.dart';
import '../../domain/usecases/get_standings.dart';

class StandingsCubit extends DataCubit<Standings> {
  StandingsCubit(this._getStandings, {super.refreshTrigger});

  final GetStandings _getStandings;

  @override
  Future<Result<Standings>> fetch({required bool fromCache}) =>
      _getStandings(fromCache: fromCache);
}

enum StandingsLayout { cards, table }

final class StandingsViewState extends Equatable {
  const StandingsViewState({
    this.layout = StandingsLayout.cards,
    this.sort = StandingsSort.rating,
  });

  final StandingsLayout layout;
  final StandingsSort sort;

  @override
  List<Object?> get props => [layout, sort];
}

/// Card/table toggle and table sort column.
class StandingsViewCubit extends Cubit<StandingsViewState> {
  StandingsViewCubit() : super(const StandingsViewState());

  void setLayout(StandingsLayout layout) =>
      emit(StandingsViewState(layout: layout, sort: state.sort));

  void sortBy(StandingsSort sort) =>
      emit(StandingsViewState(layout: state.layout, sort: sort));
}
