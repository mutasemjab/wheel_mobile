import 'package:flutter/widgets.dart';

import '../entities/enums.dart';
import '../l10n/l10n.dart';

/// Emoji per live event type.
String eventEmoji(LiveEventType type) => switch (type) {
  LiveEventType.goal => '⚽',
  LiveEventType.og => '🎁',
  LiveEventType.against => '🥅',
  LiveEventType.save => '🧤',
  LiveEventType.tackle => '🛡️',
};

String eventLabel(BuildContext context, LiveEventType type) => switch (type) {
  LiveEventType.goal => context.l10n.eventGoal,
  LiveEventType.og => context.l10n.eventOwnGoal,
  LiveEventType.against => context.l10n.eventAgainst,
  LiveEventType.save => context.l10n.eventSave,
  LiveEventType.tackle => context.l10n.eventTackle,
};
