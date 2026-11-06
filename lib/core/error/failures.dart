import 'package:equatable/equatable.dart';

/// Every error the presentation layer can see. Texts are resolved from l10n,
/// except [serverMessage] which is already Arabic text from the backend.
sealed class Failure extends Equatable {
  const Failure({this.serverMessage});

  final String? serverMessage;

  @override
  List<Object?> get props => [runtimeType, serverMessage];
}

final class NetworkFailure extends Failure {
  const NetworkFailure();
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.serverMessage});
}

final class ForbiddenFailure extends Failure {
  const ForbiddenFailure({super.serverMessage});
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure({super.serverMessage});
}

final class ConflictFailure extends Failure {
  const ConflictFailure({super.serverMessage});
}

final class ValidationFailure extends Failure {
  const ValidationFailure({super.serverMessage, this.fieldErrors = const {}});

  final Map<String, List<String>> fieldErrors;

  String? fieldError(String field) {
    final errors = fieldErrors[field];
    return errors == null || errors.isEmpty ? null : errors.first;
  }

  @override
  List<Object?> get props => [...super.props, fieldErrors];
}

final class RateLimitFailure extends Failure {
  const RateLimitFailure({super.serverMessage});
}

final class ServerFailure extends Failure {
  const ServerFailure({super.serverMessage, this.statusCode});

  final int? statusCode;

  @override
  List<Object?> get props => [...super.props, statusCode];
}

/// Response body could not be parsed into the expected shape.
final class ParsingFailure extends Failure {
  const ParsingFailure();
}

/// Data is not available locally (e.g. empty cache while offline).
final class CacheFailure extends Failure {
  const CacheFailure();
}
