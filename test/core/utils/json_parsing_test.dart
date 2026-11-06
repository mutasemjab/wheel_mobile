import 'package:flutter_test/flutter_test.dart';
import 'package:wheel_mobile/core/utils/json_parsing.dart';
import 'package:wheel_mobile/core/utils/number_format.dart';

void main() {
  group('asIntMap (tolerates old cached responses)', () {
    test(
      'empty list becomes an empty map',
      () => expect(asIntMap(<Object>[]), isEmpty),
    );
    test('null becomes an empty map', () => expect(asIntMap(null), isEmpty));
    test('drops the empty key', () {
      expect(asIntMap({'': 1, 'basel': 2}), {'basel': 2});
    });
    test('accepts doubles and numeric strings', () {
      expect(asIntMap({'a': 1.0, 'b': '3'}), {'a': 1, 'b': 3});
    });
  });

  group('parseMatchDate', () {
    test('YYYY-MM-DD is a calendar day', () {
      expect(parseMatchDate('2026-10-30'), DateTime(2026, 10, 30));
    });
    test('no time-zone shift: only the date part of a longer value counts', () {
      expect(
        parseMatchDate('2026-10-29T21:00:00.000000Z'),
        DateTime(2026, 10, 29),
      );
    });
    test('invalid input returns null in the safe variant', () {
      expect(parseMatchDateOrNull('nope'), isNull);
      expect(parseMatchDateOrNull(null), isNull);
    });
  });

  group('numbers (§5.9.4)', () {
    test('int and double are both accepted', () {
      expect(asDouble(80), 80.0);
      expect(asDouble(80.6), 80.6);
      expect(asInt(81.5), 82);
      expect(asIntOrNull(null), isNull);
    });
    test('award values are rounded to one decimal for display', () {
      expect(NumberFormatX.compact(1.8000000000000007), '1.8');
      expect(NumberFormatX.compact(2), '2');
    });
  });

  group('misc helpers', () {
    test(
      'asMap treats a list as empty',
      () => expect(asMap(<Object>[]), isEmpty),
    );
    test('asBool understands 0/1 and strings', () {
      expect(asBool(1), isTrue);
      expect(asBool('0'), isFalse);
      expect(asBool('true'), isTrue);
    });
    test('asStringList drops empty values', () {
      expect(asStringList(['a', '', null, 'b']), ['a', 'b']);
    });
  });
}
