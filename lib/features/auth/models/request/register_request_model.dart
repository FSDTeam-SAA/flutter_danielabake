// class RegisterRequestModel {
//   final String email;
//   final String password;
//
//   RegisterRequestModel({required this.email, required this.password});
//
//   Map<String, dynamic> toJson() {
//     return {
//       "email" : email,
//       "password" : password
//     };
//   }
// }

// lib/models/user_request.dart

// lib/models/user_request.dart
class RegisterRequestModel {
  final String name;
  final String email;
  final String password;
  final String? role;

  RegisterRequestModel({
    required this.name,
    required this.email,
    required this.password,
     this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}

