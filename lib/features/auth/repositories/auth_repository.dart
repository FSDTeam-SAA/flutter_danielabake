import 'package:danielabake/core/network/network_result.dart';
import 'package:danielabake/features/auth/models/request/login_request_model.dart';

import '../models/request/register_request_model.dart';
import '../models/response/auth_response_model.dart';
import '/core/network/models/refresh_token_request_model.dart';

abstract class AuthRepository {
  NetworkResult<void> login(LoginRequestModel request);
  NetworkResult<void> register(RegisterRequestModel request);

  NetworkResult<AuthResponseModel> refreshToken(
    RefreshTokenRequestModel request,
  );
}
