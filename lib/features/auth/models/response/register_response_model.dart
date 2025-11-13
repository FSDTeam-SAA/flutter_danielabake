// lib/models/user_response.dart
class RegisterResponseModel {
  final String id;
  final String email;

  RegisterResponseModel({
    required this.id,
    required this.email,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
