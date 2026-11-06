import '../../../../core/entities/enums.dart';
import '../../domain/entities/live_match_state.dart';

/// Edit operations shared by the live desk and the finished-match editor,
/// so both screens reuse the same widgets.
abstract interface class MatchEditActions {
  void addEvent(LiveEventType type, {String? player, String? assist});
  void editEvent(LiveEvent event);
  void removeEvent(String uuid);
  void setMotm(String? slug);
  void changeValues(String slug, int delta);
  void toggleUnfair(String slug);
  void toggleLate(String slug);
  void addEmergencyPlayer(String slug);
}
