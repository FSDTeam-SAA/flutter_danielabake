class RefreshTokenResponseModel {
  final String accessToken;
  final String refreshToken;

  RefreshTokenResponseModel({required this.accessToken,required this.refreshToken, });

  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponseModel(
      accessToken: json['accessToken'] ?? '', refreshToken: json['refreshToken'] ??  '',
    );
  }
}
