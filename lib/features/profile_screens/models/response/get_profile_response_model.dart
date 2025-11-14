class GetProfileResponseModel {
  final Avatar avatar;
  final String id;
  final dynamic user; // because it's null in your example
  final int totalOrders;
  final int totalFavorites;
  final String fullName;
  final String phone;
  final DateTime createdAt;
  final DateTime updatedAt;

  GetProfileResponseModel({
    required this.avatar,
    required this.id,
    required this.user,
    required this.totalOrders,
    required this.totalFavorites,
    required this.fullName,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return GetProfileResponseModel(
      avatar: Avatar.fromJson(json['avatar']),
      id: json['_id'],
      user: json['user'],
      totalOrders: json['totalOrders'],
      totalFavorites: json['totalFavorites'],
      fullName: json['fullName'],
      phone: json['phone'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Avatar {
  final String url;
  final String publicId;

  Avatar({
    required this.url,
    required this.publicId,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      url: json['url'] ?? "",
      publicId: json['public_id'] ?? "",
    );
  }
}
