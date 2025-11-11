// lib/core/network/services/auth_check_service.dart

import '../../../features/auth/models/response/auth_response_model.dart';
import '/features/auth/repositories/auth_repository.dart';
import '/core/base/base_controller.dart';
import 'package:flutx_core/core/debug_print.dart';
import '/core/network/models/refresh_token_request_model.dart';
import 'auth_storage_service.dart';

class AuthenticateCheckService extends BaseController {
  final AuthStorageService _authStorageService;
  final AuthRepository _authRepository;

  AuthenticateCheckService(this._authStorageService, this._authRepository);

  Future<bool> isAuthenticated() async {
    setLoading(true);
    final refreshToken = await _authStorageService.getRefreshToken();

    if (refreshToken == null) {
      setLoading(false);
      return false;
    }

    final result = await _authRepository.refreshToken(
      RefreshTokenRequestModel(refreshToken: refreshToken),
    );

    final isAuth = result.fold(
      (fail) {
        DPrint.info("Refresh token failed: ${fail.message}");
        setError(fail.message);
        return false;
      },
      (success) {
        _storeNewTokens(success.data);
        DPrint.info("Refresh token successful");
        return true;
      },
    );

    setLoading(false);
    DPrint.info("Auth check result: $isAuth");
    return isAuth;
  }

  Future<void> _storeNewTokens(AuthResponseModel success) async {
    try {
      if (success.accessToken != null && success.refreshToken != null) {
        await _authStorageService.storeAccessToken(
          accessToken: success.accessToken!,
        );
        await _authStorageService.storeRefreshToken(
          refreshToken: success.accessToken!,
        );
      }

      DPrint.info("Tokens stored successfully");
    } catch (e) {
      DPrint.error("Failed to store tokens: $e");
      setError("Failed to store tokens");
    }
  }
}
