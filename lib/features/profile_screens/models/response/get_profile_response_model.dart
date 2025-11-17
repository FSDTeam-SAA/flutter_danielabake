class GetProfileResponseModel {
  final String id;
  final NestedUser user;
  final String avatarUrl;
  final String fullName;
  final int totalOrders;
  final int totalFavorites;
  final String createdAt;
  final String updatedAt;
  final int v;
  final String phone;

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
    required this.phone,
  });

  factory GetProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return GetProfileResponseModel(
      id: json["_id"] ?? "",
      user: NestedUser.fromJson(json["user"] ?? {}),
      avatarUrl: json["avatarUrl"] ?? "",
      fullName: json["fullName"] ?? "",
      totalOrders: json["totalOrders"] ?? 0,
      totalFavorites: json["totalFavorites"] ?? 0,
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      v: json["__v"] ?? 0,
      phone: json["phone"] ?? "",
    );
  }
}

class NestedUser {
  final String id;
  final String name;
  final String email;

  NestedUser({
    required this.id,
    required this.name,
    required this.email,
  });

  factory NestedUser.fromJson(Map<String, dynamic> json) {
    return NestedUser(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
    );
  }
}
