import '../../../../core/utils/json_parsing.dart';
import '../../domain/entities/admin_user.dart';

class AdminUserModel {
  const AdminUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.roles,
    required this.permissions,
  });

  factory AdminUserModel.fromJson(Json json) => AdminUserModel(
    id: asInt(json['id']),
    name: asString(json['name']),
    email: asString(json['email']),
    roles: asStringList(json['roles']),
    permissions: asStringList(json['permissions']),
  );

  final int id;
  final String name;
  final String email;
  final List<String> roles;
  final List<String> permissions;

  Json toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'roles': roles,
    'permissions': permissions,
  };

  AdminUser toEntity() => AdminUser(
    id: id,
    name: name,
    email: email,
    roles: roles,
    permissions: permissions.toSet(),
  );
}

/// `POST /admin/auth/login|pin` → `data`.
class LoginResponseModel {
  const LoginResponseModel({required this.token, required this.user});

  factory LoginResponseModel.fromJson(Json json) => LoginResponseModel(
    token: asString(json['token']),
    user: AdminUserModel.fromJson(asMap(json['user'])),
  );

  final String token;
  final AdminUserModel user;
}
