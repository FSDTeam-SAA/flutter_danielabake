class GetAdminResponseModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String createdAt;
  final String updatedAt;
  final String lastLogin;
  final String avatar;
  // final List<dynamic> orders;

  GetAdminResponseModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.lastLogin,
    required this.avatar,
    // required this.orders,
  });

  factory GetAdminResponseModel.fromJson(Map<String, dynamic> json) {
    return GetAdminResponseModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      lastLogin: json['lastLogin'] ?? '',
      avatar: json['avatar'] ?? '',
      // orders: json['orders'] ?? [],
    );
  }
}
