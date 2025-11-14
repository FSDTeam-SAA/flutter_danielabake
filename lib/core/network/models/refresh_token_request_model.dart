class RefreshTokenRequestModel {
  final String? refreshToken;

  RefreshTokenRequestModel({this.refreshToken});

  Map<String, dynamic> toJson() {
    return {"refreshToken": refreshToken};
  }
}
