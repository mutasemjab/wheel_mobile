import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

/// Logs bloc errors (always) and state changes (debug only).
class AppBlocObserver extends BlocObserver {
  AppBlocObserver(this._logger, {this.verbose = false});

  final Logger _logger;
  final bool verbose;

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (verbose) {
      _logger.t('${bloc.runtimeType} → ${change.nextState.runtimeType}');
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _logger.e(
      '${bloc.runtimeType} error',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }
}
