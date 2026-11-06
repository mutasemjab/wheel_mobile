import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/utils/json_parsing.dart';
import '../models/admin_user_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<LoginResponseModel> login({
    required String email,
    required String password,
    required String deviceName,
  }) => _login(ApiEndpoints.login, {
    'email': email,
    'password': password,
    'device_name': deviceName,
  });

  Future<LoginResponseModel> loginWithPin({
    required String pin,
    required String deviceName,
  }) => _login(ApiEndpoints.pin, {'pin': pin, 'device_name': deviceName});

  Future<LoginResponseModel> _login(String path, Json body) async {
    final response = await _dio.post<Object?>(path, data: body);
    final model = LoginResponseModel.fromJson(asMap(dataOf(response.data)));
    if (model.token.isEmpty) throw const ParsingException('missing token');
    return model;
  }

  Future<AdminUserModel> me() async {
    final response = await _dio.get<Object?>(ApiEndpoints.me);
    return AdminUserModel.fromJson(asMap(dataOf(response.data)));
  }

  Future<void> logout() => _dio.post<Object?>(ApiEndpoints.logout);
}
