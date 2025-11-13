class ForgotPasswordResponseModel {
  final String otp;

  ForgotPasswordResponseModel({required this.otp});

  // Create a model from JSON (API response)
  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponseModel(
      otp: json['otp'] ?? '',
    );
  }
}
