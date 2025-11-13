class ForgotPasswordRequestModel {
  final String email;

  ForgotPasswordRequestModel({required this.email});

  // Convert model to JSON (for API request)
  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
