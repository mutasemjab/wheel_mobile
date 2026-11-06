/// Route paths used with `go_router`.
abstract final class AppRoutes {
  static const String home = '/home';
  static const String standings = '/standings';
  static const String matches = '/matches';
  static const String stats = '/stats';
  static const String more = '/more';

  static String player(String slug) => '/players/${Uri.encodeComponent(slug)}';
  static String match(String code) => '$matches/${Uri.encodeComponent(code)}';
  static const String live = '/live';
  static const String team = '/team';
  static const String rules = '/rules';

  static const String login = '/admin/login';
  static const String admin = '/admin';
  static const String liveDesk = '/admin/live';
  static const String adminMatches = '/admin/matches';
  static String adminMatch(String code) =>
      '$adminMatches/${Uri.encodeComponent(code)}';
  static String adminMatchEdit(String code) => '${adminMatch(code)}/edit';
  static const String adminPlayers = '/admin/players';
  static const String adminPlayerNew = '/admin/players/new';
  static String adminPlayerEdit(String slug) =>
      '$adminPlayers/${Uri.encodeComponent(slug)}/edit';
  static const String adminSettings = '/admin/settings';
}
