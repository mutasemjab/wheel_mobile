import '../l10n/app_localizations.dart';
import 'failures.dart';

/// User-facing text for a [Failure]. Every server error message is Arabic,
/// so it is preferred; the l10n text is the fallback when there is none
/// (no connection, parsing, cache, or an empty body).
extension FailureMessage on Failure {
  String message(AppLocalizations l10n) => switch (this) {
    NetworkFailure() => l10n.errorNetwork,
    ValidationFailure(:final serverMessage, :final fieldErrors) =>
      fieldErrors.values.expand((e) => e).firstOrNull ??
          serverMessage ??
          l10n.errorValidation,
    ParsingFailure() => l10n.errorParsing,
    CacheFailure() => l10n.errorCache,
    _ => serverMessage ?? _fallback(l10n),
  };

  String _fallback(AppLocalizations l10n) => switch (this) {
    UnauthorizedFailure() => l10n.errorUnauthorized,
    ForbiddenFailure() => l10n.errorForbidden,
    NotFoundFailure() => l10n.errorNotFound,
    ConflictFailure() => l10n.errorConflict,
    RateLimitFailure() => l10n.errorRateLimit,
    _ => l10n.errorServer,
  };
}
