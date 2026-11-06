import 'package:equatable/equatable.dart';

/// Permission names from `GET /admin/auth/me`.
abstract final class Permissions {
  static const String liveManage = 'live.manage';
  static const String matchesUpdate = 'matches.update';
  static const String matchesDelete = 'matches.delete';
  static const String playersCreate = 'players.create';
  static const String playersUpdate = 'players.update';
  static const String playersDelete = 'players.delete';
  static const String configUpdate = 'config.update';
}

final class AdminUser extends Equatable {
  const AdminUser({
    required this.id,
    required this.name,
    required this.email,
    this.roles = const [],
    this.permissions = const {},
  });

  final int id;
  final String name;
  final String email;
  final List<String> roles;
  final Set<String> permissions;

  bool can(String permission) => permissions.contains(permission);

  bool get canManageLive => can(Permissions.liveManage);
  bool get canEditMatches =>
      can(Permissions.matchesUpdate) || can(Permissions.matchesDelete);
  bool get canManagePlayers =>
      can(Permissions.playersCreate) ||
      can(Permissions.playersUpdate) ||
      can(Permissions.playersDelete);
  bool get canEditConfig => can(Permissions.configUpdate);

  @override
  List<Object?> get props => [id, name, email, roles, permissions];
}
