class CreateNewPasswordRequestModel {
  final String email;
  final String otp;
  final String newPassword;

  CreateNewPasswordRequestModel({
    required this.email,
    required this.otp,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
      'newPassword': newPassword,
    };
  }
}
