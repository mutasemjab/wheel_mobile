import 'package:logger/logger.dart';

import '../error/error_mapper.dart';
import 'result.dart';

final Logger _logger = Logger();

/// Runs a data-layer call and converts any thrown error into [Err].
Future<Result<T>> guard<T>(Future<T> Function() body) async {
  try {
    return Success<T>(await body());
  } on Object catch (error, stack) {
    final failure = ErrorMapper.map(error);
    if (error is! Exception) {
      _logger.e('Unexpected error', error: error, stackTrace: stack);
    }
    return Err<T>(failure);
  }
}
