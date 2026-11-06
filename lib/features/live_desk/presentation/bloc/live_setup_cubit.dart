import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/date_utils.dart';

enum SquadChoice {
  notCalled,
  played,
  excused;

  /// played → excused → not called → played …
  SquadChoice get next => switch (this) {
    SquadChoice.notCalled => SquadChoice.played,
    SquadChoice.played => SquadChoice.excused,
    SquadChoice.excused => SquadChoice.notCalled,
  };
}

final class LiveSetupState extends Equatable {
  const LiveSetupState({
    required this.date,
    this.opponent = '',
    this.choices = const {},
  });

  static const int minPlayed = 2;

  final DateTime date;
  final String opponent;
  final Map<String, SquadChoice> choices;

  SquadChoice choiceOf(String slug) => choices[slug] ?? SquadChoice.notCalled;

  List<String> get played => [
    for (final e in choices.entries)
      if (e.value == SquadChoice.played) e.key,
  ];

  List<String> get excused => [
    for (final e in choices.entries)
      if (e.value == SquadChoice.excused) e.key,
  ];

  bool get hasEnoughPlayers => played.length >= minPlayed;

  bool get canSubmit => hasEnoughPlayers && opponent.trim().isNotEmpty;

  LiveSetupState copyWith({
    DateTime? date,
    String? opponent,
    Map<String, SquadChoice>? choices,
  }) => LiveSetupState(
    date: date ?? this.date,
    opponent: opponent ?? this.opponent,
    choices: choices ?? this.choices,
  );

  @override
  List<Object?> get props => [date, opponent, choices];
}

/// Setup form: opponent, date (default today in Asia/Amman), squad chips.
class LiveSetupCubit extends Cubit<LiveSetupState> {
  LiveSetupCubit({DateTime? today})
    : super(LiveSetupState(date: today ?? DateUtilsX.todayInAmman()));

  void setOpponent(String value) => emit(state.copyWith(opponent: value));

  void setDate(DateTime date) =>
      emit(state.copyWith(date: DateTime(date.year, date.month, date.day)));

  void cycle(String slug) => emit(
    state.copyWith(
      choices: {...state.choices, slug: state.choiceOf(slug).next},
    ),
  );
}
