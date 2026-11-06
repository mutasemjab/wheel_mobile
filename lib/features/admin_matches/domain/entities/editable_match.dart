import 'package:equatable/equatable.dart';

import '../../../live_desk/domain/entities/live_match_state.dart';

/// `GET /admin/matches/{code}` — exactly what `PUT` accepts, held in the
/// live-desk state so the same rules and widgets edit it.
final class EditableMatch extends Equatable {
  const EditableMatch({
    required this.match,
    this.note = '',
    this.status,
    this.publishedAt,
  });

  final LiveMatchState match;
  final String note;
  final String? status;
  final String? publishedAt;

  @override
  List<Object?> get props => [match, note, status, publishedAt];
}
