class UpdateProfileResponseModel {
  final String userId;
  final String avatarUrl;
  final int totalOrders;
  final int totalFavorites;
  final String id;
  final String fullName;
  final String phone;
  final String createdAt;
  final String updatedAt;
  final int v;

  UpdateProfileResponseModel({
    required this.userId,
    required this.avatarUrl,
    required this.totalOrders,
    required this.totalFavorites,
    required this.id,
    required this.fullName,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory UpdateProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponseModel(
      userId: json['user'],
      avatarUrl: json['avatarUrl'],
      totalOrders: json['totalOrders'],
      totalFavorites: json['totalFavorites'],
      id: json['_id'],
      fullName: json['fullName'],
      phone: json['phone'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': userId,
      'avatarUrl': avatarUrl,
      'totalOrders': totalOrders,
      'totalFavorites': totalFavorites,
      '_id': id,
      'fullName': fullName,
      'phone': phone,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}
