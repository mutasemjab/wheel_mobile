import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

/// `"<device model> · WHEEL FC"` sent as Sanctum `device_name`.
abstract final class DeviceName {
  static const String appName = 'WHEEL FC';
  static const String _separator = ' · ';
  static const String _fallbackModel = 'Mobile';

  static Future<String> resolve() async {
    final info = DeviceInfoPlugin();
    var model = _fallbackModel;
    try {
      if (Platform.isAndroid) {
        model = (await info.androidInfo).model;
      } else if (Platform.isIOS) {
        model = (await info.iosInfo).modelName;
      }
    } on Exception {
      model = _fallbackModel;
    }
    return '$model$_separator$appName';
  }
}
