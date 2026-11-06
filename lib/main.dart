import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';

import 'app/app.dart';
import 'app/bloc_observer.dart';
import 'app/di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar');
  await configureDependencies();
  Bloc.observer = AppBlocObserver(sl<Logger>(), verbose: kDebugMode);
  runApp(const WheelApp());
}
