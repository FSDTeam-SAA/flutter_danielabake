class UpdateProfileResponseModel {
  final String id;
  final String user;
  final String avatarUrl;
  final String fullName;
  final int totalOrders;
  final int totalFavorites;
  final String createdAt;
  final String updatedAt;
  final int v;
  final String phone;

  UpdateProfileResponseModel({
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

  factory UpdateProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponseModel(
      id: json["_id"] ?? "",
      user: json["user"] ?? "",
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
