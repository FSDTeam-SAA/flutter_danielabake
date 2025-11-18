class ApiConstants {
  /// [Base Configuration]
  static const String baseDomain = 'http://10.10.5.33:5001'; // eshita
  //static const String baseDomain = 'https://api.azlotv.com'; // Publish
  // static const String baseDomain = 'http://18.116.214.151'; /// [AWS]
  // static const String baseDomain = 'http://192.168.0.218:8000';
  //static const String baseDomain = 'http://192.168.0.106:5001';///eshitas laptop
  static const String baseUrl = '$baseDomain/api/v1';

  /// Dynamically generated WebSocket URL based on baseDomain
  static String get webSocketUrl {
    if (baseDomain.startsWith('https://')) {
      return baseDomain.replaceFirst('https://', 'wss://');
    } else if (baseDomain.startsWith('http://')) {
      return baseDomain.replaceFirst('http://', 'ws://');
    }
    // Fallback for unexpected cases (e.g., no scheme)
    return 'ws://$baseDomain';
  }

  /// [Headers]
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> authHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };

  static Map<String, String> get multipartHeaders => {
    'Accept': 'application/json',
    // Content-Type will be set automatically for multipart
  };

  /// [Endpoint Groups
  static AuthEndpoints get auth => AuthEndpoints();
  static ProfileEndpoints get profile => ProfileEndpoints();
  static HomeEndpoints get home => HomeEndpoints();

}

/// [Authentication Endpoints]
class AuthEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/auth';

  final String login = '$_base/login';
  final String forgotPassword = '$_base/forgot-password';
  final String verifyOtp = '$_base/verify-otp';
  final String resetPassword = '$_base/reset-password';
  final String register = '$_base/register';
  final String updatePassword = '$_base/change-password';

  final String refreshToken = '$_base/refresh';
}

class ProfileEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/profile';
  String fetchProfile(String userId) => '$_base/$userId';
  String updateProfile(String userId) => '$_base/$userId';
  final String fetchOngoing = '${ApiConstants.baseUrl}/orders/my?filter=ongoing';
  // String fetchCategory(String userId) =>;
}

class HomeEndpoints {
  final String category = '${ApiConstants.baseUrl}/categories';
  final String favorite = '${ApiConstants.baseUrl}/favorites';
  // String fetchCategory(String userId) =>;
}

