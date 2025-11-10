import 'package:danielabake/core/network/api_client.dart';
import 'package:danielabake/core/network/constants/api_constants.dart';
import 'package:danielabake/core/network/models/refresh_token_request_model.dart';
import 'package:danielabake/core/network/network_result.dart';
import 'package:danielabake/features/auth/models/request/login_request_model.dart';
import 'package:danielabake/features/auth/models/request/register_request_model.dart';
import 'package:danielabake/features/auth/models/response/auth_response_model.dart';
import 'package:danielabake/features/auth/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;

  AuthRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<void> login(LoginRequestModel request) {
    return _apiClient.post(
      endpoint: ApiConstants.auth.login,
      data: request.toJson(),
      fromJsonT: (json) => {},
    );
  }

  @override
  NetworkResult<void> register(RegisterRequestModel request) {
    return _apiClient.post(
      endpoint: ApiConstants.auth.login,
      data: request.toJson(),
      fromJsonT: (json) => {},
    );
  }

  @override
  NetworkResult<AuthResponseModel> refreshToken(
    RefreshTokenRequestModel request,
  ) {
    return _apiClient.post(
      endpoint: ApiConstants.auth.refreshToken,
      data: request.toJson(),
      fromJsonT: (json) => AuthResponseModel.fromJson(json),
    );
  }
}
