/// REST paths relative to `API_BASE_URL`.
abstract final class ApiEndpoints {
  // Public
  static const String version = '/version';
  static const String home = '/home';
  static const String players = '/players';
  static String player(String slug) => '/players/${Uri.encodeComponent(slug)}';
  static const String standings = '/standings';
  static const String awards = '/awards';
  static const String leaderboards = '/leaderboards';
  static const String team = '/team';
  static const String config = '/config';
  static const String rules = '/rules';
  static const String matches = '/matches';
  static String match(String code) => '/matches/${Uri.encodeComponent(code)}';
  static const String live = '/live';

  // Admin
  static const String adminPrefix = '/admin';
  static const String login = '/admin/auth/login';
  static const String pin = '/admin/auth/pin';
  static const String me = '/admin/auth/me';
  static const String logout = '/admin/auth/logout';

  static const String adminLive = '/admin/live';
  static const String adminLiveClock = '/admin/live/clock';
  static const String adminLiveSync = '/admin/live/sync';
  static const String adminLiveFinish = '/admin/live/finish';
  static const String adminLivePublish = '/admin/live/publish';

  static const String adminMatches = '/admin/matches';
  static String adminMatch(String code) =>
      '/admin/matches/${Uri.encodeComponent(code)}';
  static String adminMatchSummary(String code) => '${adminMatch(code)}/summary';

  static const String adminPlayers = '/admin/players';
  static String adminPlayer(String slug) =>
      '/admin/players/${Uri.encodeComponent(slug)}';
  static String adminPlayerPhoto(String slug) => '${adminPlayer(slug)}/photo';
  static const String adminPlayersReorder = '/admin/players/reorder';

  static const String adminConfig = '/admin/config';
  static const String adminTeam = '/admin/team';
  static const String adminRecompute = '/admin/recompute';
  static const String adminExport = '/admin/export';

  /// Admin endpoints where a 401 means "wrong credentials", not "session expired".
  static const Set<String> credentialEndpoints = {login, pin};
}
