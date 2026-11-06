import '../../../../core/entities/clock_snapshot.dart';
import '../../../../core/result/result.dart';
import '../repositories/live_desk_repository.dart';

class SendClockHint {
  const SendClockHint(this._repository);

  final LiveDeskRepository _repository;

  Future<Result<ClockSnapshot>> call({required bool start}) =>
      _repository.sendClock(start: start);
}
