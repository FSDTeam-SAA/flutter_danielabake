import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '/core/utils/debug_print.dart';

/// Interface for token storage operations
abstract class TokenStorageService {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> storeTokens({required String accessToken, required String refreshToken});
  Future<void> clearTokens();
}

/// Interface for token refresh operations
abstract class TokenRefreshRepository {
  Future<Either<dynamic, dynamic>> refreshToken(String refreshToken);
}

/// Configuration for the RefreshTokenInterceptor
class RefreshTokenConfig {
  final String refreshEndpoint;
  final String tokenHeaderKey;
  final String tokenPrefix;
  final Duration maxRetryDelay;

  RefreshTokenConfig({
    this.refreshEndpoint = '/auth/refresh-token',
    this.tokenHeaderKey = 'Authorization',
    this.tokenPrefix = 'Bearer ',
    this.maxRetryDelay = const Duration(seconds: 30),
  });
}

class RefreshTokenInterceptor extends Interceptor {
  final Dio _dio;
  final TokenStorageService _tokenStorage;
  final TokenRefreshRepository _tokenRefreshRepository;
  final RefreshTokenConfig _config;
  bool _isRefreshing = false;
  final List<Completer<void>> _pendingRequests = [];

  RefreshTokenInterceptor({
    required Dio dio,
    required TokenStorageService tokenStorage,
    required TokenRefreshRepository tokenRefreshRepository,
    RefreshTokenConfig? config,
  })  : _dio = dio,
        _tokenStorage = tokenStorage,
        _tokenRefreshRepository = tokenRefreshRepository,
        _config = config ?? RefreshTokenConfig();

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      DPrint.info("🔄 Initiating token refresh due to 401 error");

      final completer = Completer<void>();
      _pendingRequests.add(completer);

      try {
        final refreshResult = await _refreshToken();
        if (refreshResult.isRight()) {
          // Token refresh successful, retry the original request
          final options = err.requestOptions;
          final newAccessToken = await _tokenStorage.getAccessToken();
          
          if (newAccessToken != null) {
            options.headers[_config.tokenHeaderKey] = '${_config.tokenPrefix}$newAccessToken';
            DPrint.info("🔄 Retrying request with new token for ${options.path}");
            
            try {
              final response = await _dio.request(
                options.path,
                data: options.data,
                queryParameters: options.queryParameters,
                options: Options(
                  method: options.method,
                  headers: options.headers,
                ),
              );
              return handler.resolve(response);
            } catch (retryError) {
              DPrint.error("❌ Retry failed: $retryError");
              return handler.next(err);
            }
          }
        } else {
          // Refresh failed, clear auth data
          DPrint.info("❌ Token refresh failed, clearing auth data");
          await _tokenStorage.clearTokens();
          // Navigation to login screen should be handled in the UI layer
          return handler.next(err);
        }
      } catch (e) {
        DPrint.error("❌ Token refresh error: $e");
        return handler.next(err);
      } finally {
        _isRefreshing = false;
        for (var completer in _pendingRequests) {
          completer.complete();
        }
        _pendingRequests.clear();
      }
    } else if (_isRefreshing) {
      // Queue the request if refresh is in progress
      final completer = Completer<void>();
      _pendingRequests.add(completer);
      await completer.future.timeout(_config.maxRetryDelay, onTimeout: () {
        DPrint.error("❌ Retry timeout for ${err.requestOptions.path}");
        return handler.next(err);
      });
      
      // Retry the request after refresh
      final options = err.requestOptions;
      final newAccessToken = await _tokenStorage.getAccessToken();
      
      if (newAccessToken != null) {
        options.headers[_config.tokenHeaderKey] = '${_config.tokenPrefix}$newAccessToken';
        try {
          final response = await _dio.request(
            options.path,
            data: options.data,
            queryParameters: options.queryParameters,
            options: Options(
              method: options.method,
              headers: options.headers,
            ),
          );
          return handler.resolve(response);
        } catch (retryError) {
          DPrint.error("❌ Queued retry failed: $retryError");
          return handler.next(err);
        }
      }
    }

    return handler.next(err);
  }

  Future<Either<dynamic, dynamic>> _refreshToken() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      
      if (refreshToken == null) {
        DPrint.error("❌ No refresh token available");
        return Left("No refresh token");
      }

      final result = await _tokenRefreshRepository.refreshToken(refreshToken);
      
      return result.fold(
        (failure) {
          DPrint.error("❌ Refresh token failed: $failure");
          return Left(failure);
        },
        (success) async {
          // Assuming success response contains accessToken and refreshToken
          final accessToken = success['accessToken'] ?? success.accessToken;
          final refreshToken = success['refreshToken'] ?? success.refreshToken;
          
          if (accessToken != null && refreshToken != null) {
            await _tokenStorage.storeTokens(
              accessToken: accessToken,
              refreshToken: refreshToken,
            );
            DPrint.info("✅ Token refresh successful");
            return Right(success);
          }
          return Left("Invalid token response");
        },
      );
    } catch (e) {
      DPrint.error("❌ Refresh token error: $e");
      return Left("Refresh token error: $e");
    }
  }
}