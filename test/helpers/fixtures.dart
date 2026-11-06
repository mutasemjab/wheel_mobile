import 'dart:convert';
import 'dart:io';

import 'package:wheel_mobile/core/utils/json_parsing.dart';

/// Decoded body of `test/fixtures/<name>.json`.
Object? fixtureBody(String name) =>
    jsonDecode(File('test/fixtures/$name.json').readAsStringSync());

/// The `data` member of a fixture, as a JSON object.
Json fixtureData(String name) => asMap(dataOf(fixtureBody(name)));

List<Json> fixtureList(String name) => asMapList(dataOf(fixtureBody(name)));
