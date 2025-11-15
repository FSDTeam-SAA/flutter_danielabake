class GetProfileResponseModel {
  final String id;
  final UserModel user;
  final String avatarUrl;
  final String fullName;
  final int totalOrders;
  final int totalFavorites;
  final String createdAt;
  final String updatedAt;
  final int v;

  GetProfileResponseModel({
    required this.id,
    required this.user,
    required this.avatarUrl,
    required this.fullName,
    required this.totalOrders,
    required this.totalFavorites,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory GetProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return GetProfileResponseModel(
      id: json["_id"],
      user: UserModel.fromJson(json["user"]),
      avatarUrl: json["avatarUrl"] ?? "",
      fullName: json["fullName"] ?? "",
      totalOrders: json["totalOrders"] ?? 0,
      totalFavorites: json["totalFavorites"] ?? 0,
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      v: json["__v"] ?? 0,
    );
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
    );
  }
}
