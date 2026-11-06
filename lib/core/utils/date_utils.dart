import 'package:intl/intl.dart';

/// Date helpers. Jordan (Asia/Amman) is permanently UTC+3 since 2022.
abstract final class DateUtilsX {
  static const Duration ammanOffset = Duration(hours: 3);
  static const int isoDateLength = 10;
  static const String apiPattern = 'yyyy-MM-dd';
  static const String displayPattern = 'd MMM yyyy';
  static const String compactPattern = 'yyyyMMdd';

  /// Today's calendar date in Asia/Amman.
  static DateTime todayInAmman([DateTime? now]) {
    final amman = (now ?? DateTime.now()).toUtc().add(ammanOffset);
    return DateTime(amman.year, amman.month, amman.day);
  }

  static String toApi(DateTime date) => DateFormat(apiPattern).format(date);

  static String display(DateTime date, String locale) =>
      DateFormat(displayPattern, locale).format(date);

  static String compact(DateTime date) =>
      DateFormat(compactPattern).format(date);
}
