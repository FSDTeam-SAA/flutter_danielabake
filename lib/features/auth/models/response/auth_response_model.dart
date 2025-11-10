class AuthResponseModel {
  final String? accessToken;
  final String? refreshToken;
  final String? role;
  final String? id;
  final bool? isPaid;

  const AuthResponseModel({
    this.accessToken,
    this.refreshToken,
    this.role,
    this.id,
    this.isPaid,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      id: json['_id'] as String?,
    );
  }
}
